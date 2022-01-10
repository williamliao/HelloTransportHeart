//
//  EndPoint.swift
//  HelloGitHub
//
//  Created by 雲端開發部-廖彥勛 on 2021/12/27.
//

import Foundation

enum SearchType: String {
    case bus_stop
}

struct EndPoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension EndPoint {
    static func searchNearBy(matching lat: String, lon: String, type: SearchType = .bus_stop) -> EndPoint {
        return EndPoint(
            path: "/v3/uk/places.json",
            queryItems: [
                URLQueryItem(name: "lat", value: lat),
                URLQueryItem(name: "lon", value: lon),
                URLQueryItem(name: "type", value: type.rawValue),
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
