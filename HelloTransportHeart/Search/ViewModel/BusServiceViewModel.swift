//
//  BusServiceViewModel.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation

class BusServiceViewModel {
    
    var showError: ((_ error:NetworkError) -> Void)?
    var reloadTableView: (() -> Void)?
    private let networkManager: NetworkManager
    var respone: BusServiceRespone!
    var fullTimeRespone: fullTimeTableRespone!
    private(set) var isFetching = false
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

extension BusServiceViewModel {
    func fetchData(operators: String, lineName: String) async {
        
        if isFetching {
            return
        }
        
        isFetching = true
        
        do {
            let result = try await networkManager.fetch(EndPoint.searchBusService(matching: operators, line_name: lineName), decode: { [self] json -> BusServiceRespone? in
                isFetching = false
                guard let feedResult = json as? BusServiceRespone else { return  nil }
                return feedResult
            })
            
            switch result {
                case .success(let res):
                    //print("fetchData \(res)")
                    respone = res
                    reloadTableView?()
                case .failure(let error):
                    print("fetchData error \(error)")
                    showError?(error)
            }
            
        }  catch  {
            print("fetchData error \(error)")
            showError?(error as? NetworkError ?? NetworkError.unKnown)
        }
    }
    
    func fetchFullTimeData(type: BusService.OperatorType, service: String, direction: String) async {
        do {
            let result = try await networkManager.fetch(EndPoint.showBusFullTimeTable(matching: type, service: service, direction: direction), decode: { [self] json -> fullTimeTableRespone? in
                isFetching = false
                guard let feedResult = json as? fullTimeTableRespone else { return  nil }
                return feedResult
            })
            
            switch result {
                case .success(let res):
                    print("fetchFullTimeData \(res)")
                    fullTimeRespone = res
                    reloadTableView?()
                case .failure(let error):
                    print("fetchFullTimeData error \(error)")
                    showError?(error)
            }
            
        }  catch  {
            print("fetchFullTimeData error \(error)")
            showError?(error as? NetworkError ?? NetworkError.unKnown)
        }
    }
    
    func reset() {
        isFetching = false
    }
}
