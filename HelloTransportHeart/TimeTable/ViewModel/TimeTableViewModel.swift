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
    var fullTimeTableRespone: fullTimeTableRespone!
    var sourceType: TimeTableSource.SourceType
    
    init(networkManager: NetworkManager, sourceType: TimeTableSource.SourceType) {
        self.networkManager = networkManager
        self.sourceType = sourceType
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
    
    func fetchFullTimeData(type: BusService.OperatorType, service: String, direction: String) async {
        do {
            let result = try await networkManager.fetch(EndPoint.showBusFullTimeTable(matching: type, service: service, direction: direction), decode: { json -> fullTimeTableRespone? in
                guard let feedResult = json as? fullTimeTableRespone else { return  nil }
                return feedResult
            })
            
            switch result {
                case .success(let res):
                    print("fetchFullTimeData \(res)")
                    fullTimeTableRespone = res
                    reloadCollectionView?()
                case .failure(let error):
                    print("fetchFullTimeData error \(error)")
                    showError?(error)
            }
            
        }  catch  {
            print("fetchFullTimeData error \(error)")
            showError?(error as? NetworkError ?? NetworkError.unKnown)
        }
    }
}
