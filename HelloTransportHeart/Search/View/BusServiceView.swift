//
//  BusServiceView.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import UIKit

class BusServiceView: UIView {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private let viewModel: BusServiceViewModel
    private var searchViewController: UISearchController!
    private var tableView: UITableView!
    private var navItem: UINavigationItem
    
    private var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    private var act = UIActivityIndicatorView(style: .large)
    private var spinner = UIActivityIndicatorView(style: .large)
    
    private var searchDataSource: UITableViewDiffableDataSource<Section, BusMember>!
    
    var searchType: BusService.OperatorType = .FBRI
    
    init(viewModel: BusServiceViewModel,  navItem: UINavigationItem) {
        self.viewModel = viewModel
        self.navItem = navItem
        super.init(frame: .zero)
        createView()
        configureTableView()
        makeDateSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BusServiceView {
    func createView() {
      
        searchViewController = UISearchController(searchResultsController: nil)
        searchViewController.searchBar.delegate = self
        searchViewController.obscuresBackgroundDuringPresentation = true
        searchViewController.definesPresentationContext = true
        searchViewController.searchBar.autocapitalizationType = .none
        searchViewController.obscuresBackgroundDuringPresentation = true
        searchViewController.searchBar.showsScopeBar = true
        searchViewController.isActive = true
        searchViewController.searchBar.placeholder = "Search Bus"
        searchViewController.searchBar.scopeButtonTitles = BusService.OperatorType.allCases.map { $0.rawValue }

        navItem.searchController = searchViewController
        searchViewController.hidesNavigationBarDuringPresentation = false
        navItem.hidesSearchBarWhenScrolling = false
    }
    
    func configureTableView() {
       
        tableView = UITableView()
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(BusServiceCell.self, forCellReuseIdentifier: BusServiceCell.reuseIdentifier)
        
        act.color = traitCollection.userInterfaceStyle == .light ? UIColor.black : UIColor.white
        act.translatesAutoresizingMaskIntoConstraints = false
      
        self.addSubview(tableView)
        self.addSubview(act)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            
            act.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            act.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading(isLoading: false)
                self?.isSpinnerLoading(isLoading: false)
                self?.applyInitialSnapshots()
            }
        }
        
        viewModel.showError = { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading(isLoading: false)
                self?.isSpinnerLoading(isLoading: false)
                self?.showErrorToast(error: error)
            }
        }
    }
    
    func makeDateSource() {
        makeSearchDataSource()
        tableView.dataSource = searchDataSource
    }
    
    func applyInitialSnapshots() {
        
        DispatchQueue.main.async { [self] in
 
            configureBusMember()
        }
    }
    
    func configureBusMember() {
       
        var snapshot = NSDiffableDataSourceSnapshot<Section, BusMember>()
 
        //Append available sections
        Section.allCases.forEach { snapshot.appendSections([$0]) }
        
        let results = viewModel.respone.member
        snapshot.appendItems(results, toSection: .main)
        
        if viewModel.respone.member.isEmpty {
            snapshot.appendItems([], toSection: .main)
        }
        
        searchDataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension BusServiceView {
    private func makeSearchDataSource() {
        
        searchDataSource = UITableViewDiffableDataSource<Section, BusMember>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> BusServiceCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: BusServiceCell.reuseIdentifier, for: indexPath) as? BusServiceCell
            cell?.configureCell(member: item)
            
            cell?.onInBoundAction = { [self] in
                guard let category = BusService.OperatorType(rawValue:
                                                                item.operators.code) else {
                    return
                }
                
                showActionSheet {
                    let newViewModel = TimeTableViewModel(networkManager: NetworkManager(), sourceType: .fullTime)
                    newViewModel.fetchFullTimeData(type: category, service: item.line_name, direction: "inbound")
                } detailHandler: {
                    let newViewModel = TimeTableViewModel(networkManager: NetworkManager(), sourceType: .detail)
                    newViewModel.fetchJourneyTimeData(type: category, service: item.line_name, direction: "inbound")
                }
            }
            
            cell?.onOutBoundAction = { [self] in
                guard let category = BusService.OperatorType(rawValue:
                                                                item.operators.code) else {
                    return
                }
                
                showActionSheet {
                    let newViewModel = TimeTableViewModel(networkManager: NetworkManager(), sourceType: .fullTime)
                    newViewModel.fetchFullTimeData(type: category, service: item.line_name, direction: "outbound")
                } detailHandler: {
                    let newViewModel = TimeTableViewModel(networkManager: NetworkManager(), sourceType: .detail)
                    newViewModel.fetchJourneyTimeData(type: category, service: item.line_name, direction: "outbound")
                }
                
                
            }
            
            return cell
        })
    }
}

// MARK: - UICollectionView Delegate
extension BusServiceView: UITableViewDelegate, UIScrollViewDelegate  {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height =  self.cellHeightsDictionary[indexPath]{
            return height
        }
        return UITableView.automaticDimension
    }
}

// MARK: - UISearchBarDelegate

extension BusServiceView: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
   
        guard let searchText = searchBar.text else {
            return
        }
        
        guard let category = BusService.OperatorType(rawValue:searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]) else {
            return
        }
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchText.trimmingCharacters(in: whitespaceCharacterSet)
        
        isLoading(isLoading: true)
        viewModel.reset()
        
        Task {
            await viewModel.fetchData(operators: category.rawValue, lineName: strippedString)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        closeSearchView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            closeSearchView()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        cellHeightsDictionary = [IndexPath: CGFloat]()
        
        guard let scopeButtonTitles = searchBar.scopeButtonTitles else {
            return
        }
        
        guard let category = BusService.OperatorType(rawValue:
                                                        scopeButtonTitles[selectedScope]) else {
            return
        }

        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchText.trimmingCharacters(in: whitespaceCharacterSet)
        
        closeSearchView()
        //applyInitialSnapshots()
        isLoading(isLoading: true)
        
        Task {
            await viewModel.fetchData(operators: category.rawValue, lineName: strippedString)
        }
    }
    
    func closeSearchView() {
        isLoading(isLoading: false)
        isSpinnerLoading(isLoading: false)
        viewModel.reset()
        endEditing(true)
    }
}

// MARK: - Private
extension BusServiceView {
    func isLoading(isLoading: Bool) {
        if isLoading {
            act.startAnimating()
        } else {
            act.stopAnimating()
        }
        act.isHidden = !isLoading
    }
    
    func isSpinnerLoading(isLoading: Bool) {
        if isLoading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
        spinner.isHidden = !isLoading
    }
    
    func showErrorToast(error: NetworkError) {
        print("showErrorToast \(error)")
    }
    
    func showActionSheet(timeHandler: @escaping (() -> Void), detailHandler: @escaping (() -> Void)) {
        let controller = UIAlertController(title: "TimeTable or Route Detail", message: "", preferredStyle: .actionSheet)
      
        let action = UIAlertAction(title: "TimeTable", style: .default) { action in
            timeHandler()
        }
        controller.addAction(action)
        
        let action2 = UIAlertAction(title: "Route Detail", style: .default) { action in
            detailHandler()
        }
        controller.addAction(action2)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        
        guard let presentVC = UIApplication.shared.keyWindowPresentedController else {
            return
        }
        
        presentVC.present(controller, animated: true, completion: nil)
    }
}
