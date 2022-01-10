//
//  BusServiceViewController.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import UIKit

class BusServiceViewController: UIViewController {
    
    var viewModel: BusServiceViewModel!
    var busView: BusServiceView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = BusServiceViewModel(networkManager: NetworkManager())
        
        self.title = "Time"
        busView = BusServiceView(viewModel: viewModel)
        busView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(busView)
        
        NSLayoutConstraint.activate([
            busView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            busView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            busView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            busView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
}
