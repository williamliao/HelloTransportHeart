//
//  Line.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import UIKit

struct Lines: Codable {
    let bakerloo: Bakerloo
    let central: Central
    let circle: Circle
    let district: District
    let hammersmith: Hammersmith
    let jubilee: Jubilee
    let metropolitan: Metropolitan
    let northern: Northern
    let piccadilly: Piccadilly
    let victoria: Victoria
    let waterlooandcity: Waterlooandcity
    let dlr: Dlr
}

struct LinesItem {
    private var id = UUID()
    let friendly_name: String
    let status: String
    
    init(friendly_name: String, status: String) {
        self.friendly_name = friendly_name
        self.status = status
    }
}

extension LinesItem: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: LinesItem, rhs: LinesItem) -> Bool {
        return lhs.id == rhs.id
    }
}
