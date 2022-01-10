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
        
        viewModel.reloadMapView = { [weak self] in
            DispatchQueue.main.async {
                self?.addNearByStops()
            }
        }
    }
    
    func addNearByStops() {
        
        if viewModel.nearByRespone.member.isEmpty {
            return
        }
        
        for member in viewModel.nearByRespone.member {
            
            let buswork = Buswork(title: member.name, coordinate: CLLocationCoordinate2D(latitude: member.latitude, longitude: member.longitude), atcocode: member.atcocode)
            mapView.addAnnotation(buswork)
        }
    }
}

extension NearByView: MKMapViewDelegate {
    // 1
    func mapView(
      _ mapView: MKMapView,
      viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
      // 2
      guard let annotation = annotation as? Buswork else {
        return nil
      }
      // 3
      let identifier = "Buswork"
      var view: MKMarkerAnnotationView
      // 4
      if let dequeuedView = mapView.dequeueReusableAnnotationView(
        withIdentifier: identifier) as? MKMarkerAnnotationView {
        dequeuedView.annotation = annotation
        view = dequeuedView
      } else {
        // 5
        view = MKMarkerAnnotationView(
          annotation: annotation,
          reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
      return view
    }
    
    func mapView(
      _ mapView: MKMapView,
      annotationView view: MKAnnotationView,
      calloutAccessoryControlTapped control: UIControl
    ) {
        guard let buswork = view.annotation as? Buswork else {
            return
        }

        let timeVC = TimeTableViewController()
        
        Task {
            await timeVC.fetchTimeTableData(atcode: buswork.atcocode)
        }
        
        DispatchQueue.main.async {
            self.presentTimeTableView(vc: timeVC)
        }
    }
    
    func presentTimeTableView(vc: UIViewController) {
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow }).first
      
        if let currentTabController = keyWindow?.rootViewController as? UITabBarController {
            
            if let currentNavController = currentTabController.selectedViewController as? UINavigationController {
             
                if let currentVc = currentNavController.viewControllers.first {
                    vc.modalPresentationStyle = .popover
                    if let pop = vc.popoverPresentationController {
                        let sheet = pop.adaptiveSheetPresentationController
                        sheet.detents = [.medium(), .large()]
                        
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 30.0
                        sheet.largestUndimmedDetentIdentifier = .medium
                        sheet.prefersEdgeAttachedInCompactHeight = true
                        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                    }
                    
                    currentVc.present(vc, animated: true)
                }
                
                
            }
            
            
        }
    }
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
