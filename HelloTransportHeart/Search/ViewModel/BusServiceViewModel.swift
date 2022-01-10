//
//  BusServiceViewModel.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

class BusServiceViewModel {
    
    var showError: ((_ error:NetworkError) -> Void)?
    var reloadCollectionView: (() -> Void)?
    private let networkManager: NetworkManager
    var respone: BusServiceRespone!
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}
