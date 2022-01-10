//
//  StatusViewModel.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

class StatusViewModel {
    var showError: ((_ error:NetworkError) -> Void)?
    var reloadCollectionView: (() -> Void)?
    private let networkManager: NetworkManager
    var respone: StatusResponse!
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
  
    func fetchStatusData() async {
       
        do {
            let result = try await networkManager.fetch(EndPoint.status(), decode: { json -> StatusResponse? in
                guard let feedResult = json as? StatusResponse else { return  nil }
                return feedResult
            })
            
            switch result {
                case .success(let res):
                    print("fetchStatusData \(res)")
                    respone = res
                    reloadCollectionView?()
                case .failure(let error):
                    print("fetchStatusData error \(error)")
                    showError?(error)
            }
            
        }  catch  {
            print("fetchStatusData error \(error)")
            showError?(error as? NetworkError ?? NetworkError.unKnown)
        }
    }
}
