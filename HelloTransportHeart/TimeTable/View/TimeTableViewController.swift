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
    var sourceType: TimeTableSource.SourceType
    
    init(sourceType: TimeTableSource.SourceType) {
        self.sourceType = sourceType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TimeTableViewModel(networkManager: NetworkManager(), sourceType: sourceType)
        
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
            await viewModel.fetchStopTimeTableData(atcode: atcode)
        }
    }
    
    func fetchFullTimeData(type: BusService.OperatorType, service: String, direction: String) {
        Task {
            await viewModel.fetchFullTimeData(type: type, service: service, direction: direction)
        }
    }
}
