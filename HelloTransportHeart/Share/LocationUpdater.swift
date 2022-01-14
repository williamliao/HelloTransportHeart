//
//  LocationUpdater.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import CoreLocation
import UIKit

@MainActor
class LocationUpdater: NSObject, CLLocationManagerDelegate {
    private(set) var authorizationStatus: CLAuthorizationStatus
    private(set) var authorizationAccuracyStatus: CLAccuracyAuthorization
    
    private let locationManager: CLLocationManager
    
    // The continuation we will use to asynchronously ask the user permission to track their location.
    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var permissionAccuracyContinuation: CheckedContinuation<CLAccuracyAuthorization, Never>?
    
    var locationHandler: ([CLLocation]) -> Void = { _ in }
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        locationManager = CLLocationManager()
        switch locationManager.authorizationStatus {
            case .notDetermined:
                authorizationStatus = .notDetermined
            case .authorizedAlways:
                authorizationStatus = .authorizedAlways
            case .authorizedWhenInUse:
                authorizationStatus = .authorizedWhenInUse
            case .denied:
                authorizationStatus = .denied
            case .restricted:
                authorizationStatus = .restricted
            @unknown default:
                authorizationStatus = .notDetermined
        }
        
        switch locationManager.accuracyAuthorization {
            case .fullAccuracy:
                authorizationAccuracyStatus = .fullAccuracy
            case .reducedAccuracy:
                authorizationAccuracyStatus = .reducedAccuracy
            @unknown default:
                authorizationAccuracyStatus = .fullAccuracy
        }
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
   
    private func requestPermission() async -> CLAuthorizationStatus {
        locationManager.requestWhenInUseAuthorization()
        return await withCheckedContinuation { continuation in
            permissionContinuation = continuation
        }
    }
    
    private func checkTemporaryFullAccuracyAuthorization() async throws -> CLAccuracyAuthorization {
        try await locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "AccuracyFeature")
        return await withCheckedContinuation { continuation in
            permissionAccuracyContinuation = continuation
        }
    }
    
    // MARK: - Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationHandler(locations)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        permissionContinuation?.resume(returning: authorizationStatus)
        
        authorizationAccuracyStatus = manager.accuracyAuthorization
        permissionAccuracyContinuation?.resume(returning: authorizationAccuracyStatus)
    }
}

// MARK: - Public
extension LocationUpdater {
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func beginTracking() async {
        let status = await requestPermission()
        if status == .authorizedWhenInUse {
            for await location in locationEvents() {
                print(location.coordinate)
                userLocation = location.coordinate
            }
        }
        
        do {
            let status = try await checkTemporaryFullAccuracyAuthorization()
            if status == .reducedAccuracy {
                showReducedAccuracyAlert()
            }
        } catch  {
            print("checkTemporaryFullAccuracyAuthorization Error \(error)")
        }
    }
    
    func getUserLocation() async -> CLLocationCoordinate2D? {
        return userLocation
    }
    
    func locationEvents() -> AsyncStream<CLLocation> {
        let locations = AsyncStream(CLLocation.self) { continuation in
            locationHandler = { locations in
                locations.forEach {
                    continuation.yield($0)
                }
            }
            start()
        }
        return locations
    }
}

// MARK: - Private
extension LocationUpdater {
    private func showReducedAccuracyAlert() {
        DispatchQueue.main.async {
            guard let presentVC = UIApplication.shared.keyWindowPresentedController else {
                return
            }
            
            let alertController = UIAlertController(title: "Alert", message: "Need your exact location to start navigation", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Successfully navigated to settings
                    })
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            presentVC.present(alertController, animated: true, completion: nil)
        }
    }
}
