//
//  StatusView.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import UIKit

class StatusView: UIView {
    
    private let viewModel: StatusViewModel
    
    init(viewModel: StatusViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        
    }
}
