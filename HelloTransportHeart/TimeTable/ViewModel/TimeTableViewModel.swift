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
    var timeTableRespone: TimeTableRespone!
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchTimeTableData(atcode: String) async {

        do {
            let result = try await networkManager.fetch(EndPoint.showTimeTable(matching: atcode), decode: { json -> TimeTableRespone? in
                guard let feedResult = json as? TimeTableRespone else { return  nil }
                return feedResult
            })
            
            switch result {
                case .success(let res):
                    print("fetchTimeTableData \(res)")
                    timeTableRespone = res
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
