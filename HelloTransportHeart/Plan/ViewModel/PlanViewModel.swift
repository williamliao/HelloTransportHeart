//
//  PlanViewModel.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/12.
//

import Foundation

class PlanViewModel {
    
    var showError: ((_ error:NetworkError) -> Void)?
    var reloadTableView: (() -> Void)?
    private let networkManager: NetworkManager
    var respone: PlanResponse!

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

extension PlanViewModel {
    func fetchPlanData(_ service: PlanService = .tfl) {
        
        networkManager.decoder.dateDecodingStrategy = .iso8601
        
        Task {
            do {
                let result = try await networkManager.fetch(EndPoint.showBasicPlanTable(matching: "", to: "", service: service), decode: { json -> PlanResponse? in
                    guard let feedResult = json as? PlanResponse else { return  nil }
                    return feedResult
                })
                
                switch result {
                    case .success(let res):
                        print("fetchPlanData \(res)")
                        respone = res
                        reloadTableView?()
                    case .failure(let error):
                        print("fetchPlanData error \(error)")
                        showError?(error)
                }
                
            }  catch  {
                print("fetchPlanData error \(error)")
                showError?(error as? NetworkError ?? NetworkError.unKnown)
            }
        }
    }
}
