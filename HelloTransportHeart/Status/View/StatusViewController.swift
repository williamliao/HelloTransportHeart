//
//  StatusViewController.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import UIKit

class StatusViewController: UIViewController {
    
    var viewModel: StatusViewModel!
    var statusView: StatusView!

    override func viewDidLoad() {
        super.viewDidLoad()
        renderView()
    }
    
    func renderView() {
        
        viewModel = StatusViewModel(networkManager: NetworkManager())
        
        Task {
            await viewModel.fetchStatusData()
        }
        
        self.title = "Status"
        statusView = StatusView(viewModel: viewModel)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(statusView)
        
        NSLayoutConstraint.activate([
            statusView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            statusView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            statusView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}
