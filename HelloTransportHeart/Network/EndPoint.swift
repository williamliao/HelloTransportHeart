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
    
    static func showTimeTable(matching atcocode: String, type: SearchType = .bus_stop) -> EndPoint {
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
