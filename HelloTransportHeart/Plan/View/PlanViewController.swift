//
//  PlanViewController.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/12.
//

import UIKit

class PlanViewController: UIViewController {
    
    var viewModel: PlanViewModel!
    var planView: PlanView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PlanViewModel(networkManager: NetworkManager())

        self.title = "Plan"
        planView = PlanView(viewModel: viewModel)
        planView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(planView)
        
        NSLayoutConstraint.activate([
            planView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            planView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            planView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            planView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        
        viewModel.fetchPlanData()
    }
}
