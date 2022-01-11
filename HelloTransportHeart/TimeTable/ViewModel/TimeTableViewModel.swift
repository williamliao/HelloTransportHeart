//
//  TimeTableViewModel.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

class TimeTableViewModel {
    
    var showError: ((_ error:NetworkError) -> Void)?
    var reloadCollectionView: (() -> Void)?
    private let networkManager: NetworkManager
    var stopTimeTableRespone: StopTimeTableRespone!
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchStopTimeTableData(atcode: String) async {

        do {
            let result = try await networkManager.fetch(EndPoint.showStopTimeTable(matching: atcode), decode: { json -> StopTimeTableRespone? in
                guard let feedResult = json as? StopTimeTableRespone else { return  nil }
                return feedResult
            })
            
            switch result {
                case .success(let res):
                    print("fetchTimeTableData \(res)")
                    stopTimeTableRespone = res
                    reloadCollectionView?()
                case .failure(let error):
                    print("fetchTimeTableData error \(error)")
                    showError?(error)
            }
            
        }  catch  {
            print("fetchTimeTableData error \(error)")
            showError?(error as? NetworkError ?? NetworkError.unKnown)
        }
    }
}
