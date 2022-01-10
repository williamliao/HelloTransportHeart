//
//  StatusResponse.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

struct StatusResponse: Codable {
    let request_time: String
    let lines: Lines
    let status_refresh_time: String
}
