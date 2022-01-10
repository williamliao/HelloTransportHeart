//
//  BusStop.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import CoreLocation
import MapKit

class Buswork: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let atcocode: String

    init(
        title: String?,
        coordinate: CLLocationCoordinate2D,
        atcocode: String) {
        self.title = title
        self.coordinate = coordinate
        self.atcocode = atcocode
        super.init()
    }
}
