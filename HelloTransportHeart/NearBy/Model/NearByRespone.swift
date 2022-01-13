//
//  NearByRespone.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

struct NearByRespone: Codable {
    let request_time: String
    let source: String
    let acknowledgements: String
    let member: [Member]
}

struct Member: Codable {
    let type: String
    let name: String
    let latitude: Double
    let longitude: Double
    let accuracy: Int
    let description: String?
    let atcocode: String?
    let distance: Double?
    let osm_id: String?
    let station_code: String?
    let tiploc_code: String?
}

struct PlacesTextSearchRespone: Codable {
    let request_time: String
    let source: String
    let acknowledgements: String
    let member: [Member]
}
