//
//  LocationClient.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import CoreLocation

protocol LocationClient {
    
    func beginTracking() async
    func getUserLocation() async -> CLLocationCoordinate2D?
    func getFrom() async -> String
    func getTo() async -> String
}

class LocalLocationClient: LocationClient {
    
    private let locationUpdater: LocationUpdater = LocationUpdater()
   
    func beginTracking() async {
        await locationUpdater.beginTracking()
    }
    
    func getUserLocation() async -> CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: 51.534121, longitude: 0.006944)
    }
    
    func getGPSFrom() async -> String {
        return "51.529258, -0.134649"
    }

    func getGPSTo() async -> String {
        return "51.506383 -0.088780"
    }
    
    func getFrom() async -> String {
        return "postcode:st52qd"
    }

    func getTo() async -> String {
        return "postcode:ex85jf"
    }
}
