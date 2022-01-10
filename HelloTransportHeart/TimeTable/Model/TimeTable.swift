//
//  TimeTable.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

struct TimeTableRespone: Codable {
    let atcocode: String
    let request_time: String
    let smscode: String
    let name: String
    let stop_name: String
    let bearing: String
    let indicator: String
    let locality: String
    let location: Location
    let departures: [String: [BusItem]]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        atcocode = try values.decode(String.self, forKey: .atcocode)
        request_time = try values.decode(String.self, forKey: .request_time)
        smscode = try values.decode(String.self, forKey: .smscode)
        stop_name = try values.decode(String.self, forKey: .stop_name)
        bearing = try values.decode(String.self, forKey: .bearing)
        indicator = try values.decode(String.self, forKey: .indicator)
        locality = try values.decode(String.self, forKey: .locality)
        location = try values.decode(Location.self, forKey: .location)
        departures = try values.decode([String: [BusItem]].self, forKey: .departures)
    }
}

extension TimeTableRespone: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(atcocode)
    }

    static func == (lhs: TimeTableRespone, rhs: TimeTableRespone) -> Bool {
        return lhs.atcocode == rhs.atcocode
    }
}

struct Location:Codable {
    let type: String
    let coordinates: [Double]
}

struct BusItem: Codable {
    let mode: String
    let line: String
    let line_name: String
    let direction: String
    let operator_mark: String
    let operator_name: String
    let date: String
    let aimed_departure_time: String
    let expected_departure_date: String?
    let expected_departure_time: String?
    let best_departure_estimate: String
    let dir: String
    let id: String
    let source: String
    
    private enum CodingKeys : String, CodingKey {
        case id
        case mode
        case line
        case line_name
        case direction
        case operator_mark = "operator"
        case operator_name
        case date
        case aimed_departure_time
        case expected_departure_date
        case expected_departure_time
        case best_departure_estimate
        case dir
        case source
    }
}

extension BusItem: Hashable, Equatable {
    static func == (lhs: BusItem, rhs: BusItem) -> Bool {
        guard lhs.id == rhs.id
        else { return false }
        
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
