//
//  EndPoint.swift
//  HelloGitHub
//
//  Created by 雲端開發部-廖彥勛 on 2021/12/27.
//

import Foundation

enum SearchType: String {
    case bus_stop
    case train_station
}

enum PlanService: String {
    case tfl
    case silverrail
}

enum PlanMode: String {
    case bus
    case train
    case tube
    case boat
    case bus_train_boat = "bus-train-boat"
}

enum PlaceTextSearchType: String {
    case train_station
    case bus_stop
    case tube_station
    case settlement //geocoding match for a city/town/village/suburb/neighbourhood
    case region
    case street
    case poi //point of interest
    case postcode
}

struct EndPoint {
    let path: String
    let queryItems: [URLQueryItem]
    static let api_key: String = ""
    static let app_id: String = ""
}

extension EndPoint {
    static func searchNearBy(matching lat: String, lon: String, type: SearchType = .bus_stop) -> EndPoint {
        return EndPoint(
            path: "/v3/uk/places.json",
            queryItems: [
                URLQueryItem(name: "lat", value: lat),
                URLQueryItem(name: "lon", value: lon),
                URLQueryItem(name: "type", value: type.rawValue),
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func showStopTimeTable(matching atcocode: String, type: SearchType = .bus_stop) -> EndPoint {
        return EndPoint(
            path: "/v3/uk/bus/stop/\(atcocode)/timetable.json",
            queryItems: [
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func status() -> EndPoint {
        return EndPoint(
            path: "/v3/uk/tube/lines.json",
            queryItems: [
                URLQueryItem(name: "include_status", value: "true"),
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func searchBusService(matching operators: String, line_name: String) -> EndPoint {
        return EndPoint(
            path: "/v3/uk/bus/services.json",
            queryItems: [
                URLQueryItem(name: "operator", value: operators),
                URLQueryItem(name: "line_name", value: line_name),
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func showBusFullTimeTable(matching operators: BusService.OperatorType = .FBRI, service: String, direction: String) -> EndPoint {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return EndPoint(
            path: "/v3/uk/bus/service_timetables.json",
            queryItems: [
                URLQueryItem(name: "operator", value: operators.rawValue),
                URLQueryItem(name: "service", value: service),
                URLQueryItem(name: "direction", value: direction),
                URLQueryItem(name: "date", value: formatter.string(from: Date())),
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func showBusJourneyTable(matching operators: BusService.OperatorType = .FBRI, service: String, direction: String) -> EndPoint {
        return EndPoint(
            path: "/v3/uk/bus/route/\(operators)/\(service)/\(direction)/timetable.json",
            queryItems: [
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func showBasicPlanTable(matching from: String, to: String, service: PlanService) -> EndPoint {
       
        return EndPoint(
            path: "/v3/uk/public/journey/from/\(from)/to/\(to).json",
            queryItems: [
                URLQueryItem(name: "service", value: service.rawValue),
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func showRestrictsToOnlyPlanTable(matching from: String, to: String, modes: PlanMode = .bus, service: PlanService = .tfl) -> EndPoint {
       
        return EndPoint(
            path: "/v3/uk/public/journey/from/\(from)/to/\(to).json",
            queryItems: [
                URLQueryItem(name: "service", value: service.rawValue),
                URLQueryItem(name: "modes", value: modes.rawValue),
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func showRestrictsExceptPlanTable(matching from: String, to: String, not_modes: PlanMode = .bus, service: PlanService = .tfl) -> EndPoint {
       
        return EndPoint(
            path: "/v3/uk/public/journey/from/\(from)/to/\(to).json",
            queryItems: [
                URLQueryItem(name: "service", value: service.rawValue),
                URLQueryItem(name: "not_modes", value: not_modes.rawValue),
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func placesTextSearch(matching query: String, types: [PlaceTextSearchType] = [.bus_stop]) -> EndPoint {
        
        var queryTypes = types
        var typeStr = queryTypes.first!.rawValue
        queryTypes.removeFirst()
        
        for type in queryTypes {
            typeStr += "," + type.rawValue
        }

        return EndPoint(
            path: "/v3/uk/places.json",
            queryItems: [
                URLQueryItem(name: "type", value: typeStr),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
            ]
        )
    }
    
    static func showTrainStationTimetable(matching trainStation: String) -> EndPoint {
       
        return EndPoint(
            path: "/v3/uk/train/station/\(trainStation)/timetable.json",
            queryItems: [
                URLQueryItem(name: "app_key", value: api_key),
                URLQueryItem(name: "app_id", value: app_id),
                URLQueryItem(name: "train_status", value: "passenger"),
            ]
        )
    }
}

extension EndPoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "transportapi.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
