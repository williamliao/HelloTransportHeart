//
//  NearByViewController.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import UIKit

class NearByViewController: UIViewController {
    
    var viewModel: NearByViewModel!
    var nearByView: NearByView!

    override func viewDidLoad() {
        super.viewDidLoad()
        renderView()
    }

    func renderView() {
        
        viewModel = NearByViewModel(networkManager: NetworkManager(), locationClient: LocalLocationClient())
        
        let locationUpdater = LocationUpdater()
        Task {
            await locationUpdater.beginTracking()
        }
        
        viewModel.fetchNearByData()
        
        self.title = "BusStop"
        nearByView = NearByView(viewModel: viewModel)
        nearByView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(nearByView)
        
        NSLayoutConstraint.activate([
            nearByView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            nearByView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            nearByView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            nearByView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }

}
