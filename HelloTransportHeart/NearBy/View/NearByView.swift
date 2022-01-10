//
//  NearByView.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import UIKit
import MapKit

class NearByView: UIView {
    private var mapView: MKMapView!
    
    private let viewModel: NearByViewModel
   
    init(viewModel: NearByViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapView)
        
        Task {
            if let loc = await viewModel.locationClient.getUserLocation() {
                let initialLocation = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                mapView.centerToLocation(initialLocation)
            }
        }
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func addNearByStops() {
        Task {
            await viewModel.fetchNearByData()
        }
    }
}

extension NearByView: MKMapViewDelegate {
    
}

private extension MKMapView {
    func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
          center: location.coordinate,
          latitudinalMeters: regionRadius,
          longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
