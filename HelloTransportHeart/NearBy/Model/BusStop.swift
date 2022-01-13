//
//  BusStop.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import CoreLocation
import MapKit

class Buswork: NSObject, MKAnnotation {

    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let atcocode: String?
    let memberType: MemberType
    let osm_id: String?
    let station_code: String?
    let tiploc_code:String?

    init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D,
        atcocode: String?,
        osm_id: String?,
        station_code: String?,
        tiploc_code:String?,
        memberType: MemberType) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.atcocode = atcocode
        self.memberType = memberType
        self.osm_id = osm_id
        self.tiploc_code = tiploc_code
        self.station_code = station_code
        super.init()
    }
}

enum MemberType: CaseIterable, RawRepresentable {
    typealias RawValue = String
    
    case bus_stop
    case train_station
    case settlement
    case tram_stop
    case tube_station
    
    init?(rawValue: RawValue) {
        switch rawValue {
            case "bus_stop": self = .bus_stop
            case "train_station": self = .train_station
            case "settlement": self = .settlement
            case "tram_stop": self = .tram_stop
            case "tube_station": self = .tube_station
            default: return nil
        }
    }

    var rawValue: RawValue {
        switch self {
            case .bus_stop: return "bus_stop"
            case .train_station: return "train_station"
            case .settlement: return "settlement"
            case .tram_stop: return "tram_stop"
            case .tube_station: return "tube_station"
        }
    }
}
