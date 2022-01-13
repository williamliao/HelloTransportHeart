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
    private var navItem: UINavigationItem
    
    let searchController: UISearchController = {
        let sc = UISearchController()
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = NSLocalizedString("Search Directions", comment: "")
        sc.definesPresentationContext = true
        sc.searchBar.autocapitalizationType = .none
        return sc
    }()
   
    init(viewModel: NearByViewModel, navItem: UINavigationItem) {
        self.viewModel = viewModel
        self.navItem = navItem
        super.init(frame: .zero)
        createSearchView()
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSearchView() {
        navItem.searchController = searchController
        navItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func createView() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapView)
        
        moveToUserLocation()
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        ])
        
        viewModel.reloadNearByMapView = { [weak self] in
            DispatchQueue.main.async {
                self?.addNearByStops()
            }
        }
        
        viewModel.reloadPlaceSearchMapView = { [weak self] in
            DispatchQueue.main.async {
                self?.addPlaceTextSearch()
            }
        }
    }
    
    func addNearByStops() {
        
        if viewModel.nearByRespone.member.isEmpty {
            return
        }
        
        for member in viewModel.nearByRespone.member {
            
            guard let type = MemberType(rawValue:member.type) else{
                return
            }
            
            let buswork = Buswork(title: member.name, subtitle: member.type, coordinate: CLLocationCoordinate2D(latitude: member.latitude, longitude: member.longitude), atcocode: member.atcocode,osm_id: member.osm_id, station_code: member.station_code, tiploc_code: member.tiploc_code, memberType: type)
            mapView.addAnnotation(buswork)
        }
    }
    
    func addPlaceTextSearch() {
        
        if viewModel.placesTextSearchRespone.member.isEmpty {
            return
        }
        
        let initialLocation = CLLocation(latitude: viewModel.placesTextSearchRespone.member[0].latitude, longitude: viewModel.placesTextSearchRespone.member[0].longitude)
        mapView.centerToLocation(initialLocation)
        
        for member in viewModel.placesTextSearchRespone.member {
            
            guard let type = MemberType(rawValue:member.type) else{
                return
            }
            
            let buswork = Buswork(title: member.name, subtitle: member.type, coordinate: CLLocationCoordinate2D(latitude: member.latitude, longitude: member.longitude), atcocode: member.atcocode,osm_id: member.osm_id, station_code: member.station_code, tiploc_code: member.tiploc_code, memberType: type)
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
        view.animatesWhenAdded = true
        view.subtitleVisibility = .visible
        return view
    }
    
    func mapView(
      _ mapView: MKMapView,
      annotationView view: MKAnnotationView,
      calloutAccessoryControlTapped control: UIControl
    ) {
        guard let buswork = view.annotation as? Buswork, let attcode = buswork.atcocode  else {
            return
        }
        
        switch buswork.memberType {
            case .bus_stop:
                let viewModel = TimeTableViewModel(networkManager: NetworkManager(), sourceType: .stop)
                let timeVC = TimeTableViewController(viewModel: viewModel)
                timeVC.fetchTimeTableData(atcode: attcode)
                DispatchQueue.main.async {
                    self.presentTimeTableView(vc: timeVC)
                }
            default:
                break
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
    
    func moveToUserLocation() {
        Task {
            if let loc = await viewModel.locationClient.getUserLocation() {
                let initialLocation = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                mapView.centerToLocation(initialLocation)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension NearByView: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
   
        guard let searchText = searchBar.text else {
            return
        }
      
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchText.trimmingCharacters(in: whitespaceCharacterSet)
     
        viewModel.fetchPlacesTextSearch(query: strippedString) //Waterloo
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        closeSearchView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            closeSearchView()
        }
    }
   
    func closeSearchView() {
        endEditing(true)
        moveToUserLocation()
    }
}
