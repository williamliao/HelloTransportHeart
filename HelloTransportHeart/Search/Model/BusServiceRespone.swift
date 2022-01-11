//
//  BusServiceRespone.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

struct BusServiceRespone: Codable {
    let id: String
    let request_time: String
    let source: String
    let acknowledgements: String
    let member: [BusMember]
}

struct BusMember: Codable {
    let id: String
    let operators: Operators
    let line: String
    let line_name: String
    let centroid: Centroid
    let directions: [Directions]
    
    private enum CodingKeys : String, CodingKey {
        case id
        case operators = "operator"
        case line
        case line_name
        case centroid
        case directions
    }
}

extension BusMember: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: BusMember, rhs: BusMember) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Operators: Codable {
    let code: String
    let name: String
}

struct Centroid: Codable {
    let type: String
    let coordinates: [Double]
}

struct Directions: Codable {
    let name: String
    let destination: Destination
}

struct Destination: Codable {
    let description: String
}

struct BusService: Codable {
    enum OperatorType: Codable {
        case FBRI
        case FPOT //First Potteries
        case FLDS //First Leeds
        case WRAY //Arriva Yorkshire
        case SD //Stagecoach South West
    }
}

extension BusService.OperatorType: CaseIterable { }

extension BusService.OperatorType: RawRepresentable {
    typealias RawValue = String

    init?(rawValue: RawValue) {
        switch rawValue {
            case "FBRI": self = .FBRI
            case "FPOT": self = .FPOT
            case "FLDS": self = .FLDS
            case "WRAY": self = .WRAY
            case "SD": self = .SD
            default: return nil
        }
    }

    var rawValue: RawValue {
        switch self {
            case .FBRI: return "FBRI"
            case .FPOT: return "FPOT"
            case .FLDS: return "FLDS"
            case .WRAY: return "WRAY"
            case .SD: return "SD"
        }
    }
}
