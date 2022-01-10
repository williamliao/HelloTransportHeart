//
//  LocationClient.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import CoreLocation

protocol LocationClient {
    
    func requestPermission() async -> CLAuthorizationStatus
    func beginTracking() async
    func getUserLocation() async -> CLLocationCoordinate2D?
}

class LocalLocationClient: LocationClient {
    
    private let locationUpdater: LocationUpdater = LocationUpdater()
    
    func requestPermission() async -> CLAuthorizationStatus {
        return await locationUpdater.requestPermission()
    }
    
    func beginTracking() async {
        await locationUpdater.beginTracking()
    }
    
    func getUserLocation() async -> CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: 51.534121, longitude: 0.006944)
    }
}
