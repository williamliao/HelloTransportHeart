//
//  MapView.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/12.
//

import UIKit
import MapKit

class MapView: UIView {
    
    let viewModel: MapRouteViewModel
    var mapView: MKMapView!
    
    init(viewModel: MapRouteViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        //configureMapView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func configureMapView() {
        
        mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let initialLocation = CLLocation(latitude: 51.534121, longitude: 0.006944)
        mapView.centerToLocation(initialLocation)
       
        let sourceLat = viewModel.sourceCoordinates[1]
        let sourceLng = viewModel.sourceCoordinates[0]

        let destinationLat = viewModel.destinationCoordinates[1]
        let destinationLng = viewModel.destinationCoordinates[0]

        let sourceLocation = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLng)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)

        let destinationLocation = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Source"

        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }

        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "destination"

        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)

        let directionRequest = MKDirections.Request()
        directionRequest.transportType = .automobile
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem

        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let routes = response.routes
            for route in routes {
                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)

                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }

}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
    
        return renderer
    }
}
