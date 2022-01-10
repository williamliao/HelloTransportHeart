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
