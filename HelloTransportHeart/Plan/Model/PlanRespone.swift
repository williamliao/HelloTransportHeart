//
//  PlanRespone.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/12.
//

import Foundation

struct PlanResponse: Codable {
    let request_time: Date
    let source: String
    let acknowledgements: String
    let routes: [Routes]
}

struct Routes: Codable {
    let duration: String
    let route_parts: [Route_parts]
    let departure_time: String
    let arrival_time: String
    let departure_datetime: Date
    let arrival_datetime: Date
    let distance: Int
    let distance_desc: String?
}

extension Routes: Hashable, Equatable {
    static func == (lhs: Routes, rhs: Routes) -> Bool {
        guard lhs.duration == rhs.duration
        else { return false }
        
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(duration)
    }
}

struct Route_parts: Codable {
    let mode: String
    let from_point_name: String
    let from_point: From_point
    let to_point_name: String
    let to_point: To_point
    let destination: String
    let destination_point: Destination_point
    let line_name: String
    let duration: String
    let departure_time: String
    let arrival_time: String
    let departure_datetime: String
    let arrival_datetime: String
    let coordinates: [Coordinates]
    let distance: Int
    let distance_desc: String
}

struct Coordinates: Codable {
    let point: [[Double]]
}

struct Destination_point: Codable {
    let place: Place?
}

struct From_point: Codable {
    let place: Place?
}

struct To_point: Codable {
    let place: Place?
}

struct Place: Codable {}
