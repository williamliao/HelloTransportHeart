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
    private var matchingItems:[MKMapItem] = []
    
    private let searchController: UISearchController = {
        let sc = UISearchController()
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = NSLocalizedString("Search Directions", comment: "")
        sc.definesPresentationContext = true
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.autocapitalizationType = .none
        return sc
    }()
    
    private enum Section: CaseIterable {
        case main
    }
    
    private var searchDataSource: UITableViewDiffableDataSource<Section, MKMapItem>!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
   
    init(viewModel: NearByViewModel, navItem: UINavigationItem) {
        self.viewModel = viewModel
        self.navItem = navItem
        super.init(frame: .zero)
        createView()
        createSearchView()
        makeSearchDataSource()
        createTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createTableView() {
        
        tableView.delegate = self
        tableView.dataSource = searchDataSource
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NearBySearchCell.self, forCellReuseIdentifier: NearBySearchCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.isHidden = true
        
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func createSearchView() {
        navItem.searchController = searchController
        navItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
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
        
        viewModel.showError = { [weak self] error in
            switch error {
            case .other(let message):
                self?.showError(message: message)
            default:
                self?.showError(message: error.localizedDescription)
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
        guard let buswork = view.annotation as? Buswork else {
            return
        }
        
        switch buswork.memberType {
            case .bus_stop, .tram_stop, .tube_station:
                if let attcode = buswork.atcocode {
                    let viewModel = TimeTableViewModel(networkManager: NetworkManager(), sourceType: .stop)
                    let timeVC = TimeTableViewController(viewModel: viewModel)
                    timeVC.fetchTimeTableData(atcode: attcode)
                    DispatchQueue.main.async {
                        self.presentTimeTableView(vc: timeVC)
                    }
                }
            case .train_station:
                if let station_code = buswork.station_code {
                    let viewModel = TimeTableViewModel(networkManager: NetworkManager(), sourceType: .train)
                    let timeVC = TimeTableViewController(viewModel: viewModel)
                    timeVC.fetchTrainStationTimeData(station_code: station_code)
                    DispatchQueue.main.async {
                        self.presentTimeTableView(vc: timeVC)
                    }
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
                        
                        sheet.prefersGrabberVisible = false
                        sheet.preferredCornerRadius = 30.0
                        sheet.sourceView = vc.view
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
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {}
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        closeSearchView()
        //moveToUserLocation()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            closeSearchView()
        }
    }
   
    func closeSearchView() {
        DispatchQueue.main.async { [self] in
            searchController.searchBar.resignFirstResponder()
            tableView.isHidden = true
            matchingItems = [MKMapItem]()
            tableView.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension NearByView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        
        tableView.isHidden = false
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { [self] response, _ in
            guard let response = response else {
                return
            }
            matchingItems = response.mapItems
            applyInitialSnapshots()
        }
    }
    
    private func parseAddress(_ selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

// MARK: - UITableViewDiffableDataSource
extension NearByView {
    private func makeSearchDataSource() {
        
        searchDataSource = UITableViewDiffableDataSource<Section, MKMapItem>(tableView: tableView, cellProvider: { [ self] (tableView, indexPath, item) -> NearBySearchCell in
           
            let cell = tableView.dequeueReusableCell(withIdentifier: NearBySearchCell.reuseIdentifier, for: indexPath) as! NearBySearchCell
            
            if matchingItems.isEmpty {
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                return cell
            }
            
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel?.text = parseAddress(selectedItem)
            cell.textLabel?.textColor = .label
            cell.detailTextLabel?.textColor = .label
            return cell
        })
    }
    
    private func applyInitialSnapshots() {
        
        DispatchQueue.main.async { [self] in
 
            configureMapItem()
        }
    }
    
    private func configureMapItem() {
       
        var snapshot = NSDiffableDataSourceSnapshot<Section, MKMapItem>()
 
        //Append available sections
        Section.allCases.forEach { snapshot.appendSections([$0]) }
        
        snapshot.appendItems(matchingItems, toSection: .main)
        
        if matchingItems.isEmpty {
            snapshot.appendItems([], toSection: .main)
        }
    
        searchDataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension NearByView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
       
        guard let searchText = selectedItem.name else {
            return
        }
       
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchText.trimmingCharacters(in: whitespaceCharacterSet)
     
        closeSearchView()
        viewModel.fetchPlacesTextSearch(query: strippedString) //Waterloo
    }
}

extension NearByView {
    func showError(message: String) {
        DispatchQueue.main.async {
            
            guard let presentVC = UIApplication.shared.keyWindowPresentedController else {
                return
            }
            
            let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: message, preferredStyle: .alert)
     
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { action in
                
            })
            presentVC.present(alertController, animated: true, completion: nil)
        }
    }
}
