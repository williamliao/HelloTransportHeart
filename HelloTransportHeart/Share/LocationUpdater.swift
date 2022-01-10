//
//  LocationUpdater.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import CoreLocation

@MainActor
class LocationUpdater: NSObject, CLLocationManagerDelegate {
    private(set) var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager: CLLocationManager
    
    // The continuation we will use to asynchronously ask the user permission to track their location.
    private var permissionContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    
    var locationHandler: ([CLLocation]) -> Void = { _ in }
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestPermission() async -> CLAuthorizationStatus {
        locationManager.requestWhenInUseAuthorization()
        return await withCheckedContinuation { continuation in
            permissionContinuation = continuation
        }
    }
    
    func beginTracking() async {
        let status = await requestPermission()
        if status == .authorizedWhenInUse {
            for await location in locationEvents() {
                print(location.coordinate)
                userLocation = location.coordinate
            }
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
    
    // MARK: - Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationHandler(locations)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        permissionContinuation?.resume(returning: authorizationStatus)
    }
}
