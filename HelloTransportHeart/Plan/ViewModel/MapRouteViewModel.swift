//
//  MapRouteViewModel.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/12.
//

import Foundation

class MapRouteViewModel {
    let sourceCoordinates: [Double]
    let destinationCoordinates: [Double]
    
    init(sourceCoordinates: [Double], destinationCoordinates: [Double]) {
        self.sourceCoordinates = sourceCoordinates
        self.destinationCoordinates = destinationCoordinates
    }
}
