//
//  TimeTable.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

struct StopTimeTableRespone: Codable {
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

extension StopTimeTableRespone: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(atcocode)
    }

    static func == (lhs: StopTimeTableRespone, rhs: StopTimeTableRespone) -> Bool {
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

struct fullTimeTableRespone: Codable {
    let id: String
    let member: [FullBusMember]
}

struct FullBusMember: Codable {
    let request_time: String
    let operators: String
    let operator_name: String
    let line: String
    let line_name: String
    let origin_atcocode: String
    let dir: String
    let id: String
    let stops: [Stops]
    
    private enum CodingKeys : String, CodingKey {
        case request_time
        case id
        case operators = "operator"
        case operator_name
        case line
        case line_name
        case origin_atcocode
        case dir
        case stops
    }
}

extension FullBusMember: Hashable, Equatable {
    static func == (lhs: FullBusMember, rhs: FullBusMember) -> Bool {
        guard lhs.id == rhs.id
        else { return false }
        
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Stops: Codable {
    let time: String
    let date: String
    let atcocode: String
    let name: String
    let stop_name: String
    let smscode: String
    let locality: String
    let bearing: String?
    let indicator: String?
    let latitude: Double
    let longitude: Double
    let timing_point: Bool
}

extension Stops: Hashable, Equatable {
    static func == (lhs: Stops, rhs: Stops) -> Bool {
        guard lhs.time == rhs.time
        else { return false }
        
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
}

struct TimeTableSource: Codable {
    enum SourceType: Codable {
        case stop
        case fullTime
        case detail
        case train
    }
}

struct BusJourneyResponse: Codable {
    let request_time: String
    let operators: String
    let operator_name: String
    let line: String
    let line_name: String
    let origin_atcocode: String
    let dir: String
    let id: String
    let stops: [Stops]
    
    private enum CodingKeys : String, CodingKey {
        case request_time
        case id
        case operators = "operator"
        case operator_name
        case line
        case line_name
        case origin_atcocode
        case dir
        case stops
    }
}

struct TrainStationTimetableResponse: Codable {
    let date: String
    let time_of_day: String
    let request_time: String
    let station_name: String
    let station_code: String
    let departures: Departures
}

struct Departures: Codable {
    let all: [All]
}

struct All: Codable {
    let mode: String
    let service: String
    let train_uid: String
    let platform: String
    let operators: String
    let operator_name: String
    let aimed_departure_time: String
    let aimed_arrival_time: String
    let aimed_pass_time: Aimed_pass_time
    let origin_name: String
    let destination_name: String
    let source: String
    let category: String
    let service_timetable: Service_timetable
    
    private enum CodingKeys : String, CodingKey {
        case mode
        case service
        case train_uid
        case platform
        case operators = "operator"
        case operator_name
        case aimed_departure_time
        case aimed_arrival_time
        case aimed_pass_time
        case origin_name
        case destination_name
        case source
        case category
        case service_timetable
    }
}

extension All: Hashable, Equatable {
    static func == (lhs: All, rhs: All) -> Bool {
        guard lhs.train_uid == rhs.train_uid
        else { return false }
        
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(train_uid)
    }
}

struct Aimed_pass_time: Codable {
}

struct Service_timetable: Codable {
    let id: String
}
