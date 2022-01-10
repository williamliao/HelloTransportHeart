//
//  TimeTableViewController.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import UIKit

class TimeTableViewController: UIViewController {
    
    var viewModel: TimeTableViewModel!
    var timeTableView: TimeTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TimeTableViewModel(networkManager: NetworkManager())
        
        self.title = "Time"
        timeTableView = TimeTableView(viewModel: viewModel)
        timeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(timeTableView)
        
        NSLayoutConstraint.activate([
            timeTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            timeTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            timeTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            timeTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func fetchTimeTableData(atcode: String) async {
        Task {
            await viewModel.fetchTimeTableData(atcode: atcode)
        }
    }
    
    func presentExifView(vc: UIViewController) {
        
    }
}