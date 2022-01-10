//
//  NearByViewModel.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import CoreLocation

class NearByViewModel {

    var showError: ((_ error:NetworkError) -> Void)?
    private let networkManager: NetworkManager
    let locationClient: LocationClient
    var nearByRespone: NearByRespone!
    
    init(networkManager: NetworkManager, locationClient: LocationClient) {
        self.networkManager = networkManager
        self.locationClient = locationClient
    }
  
    func fetchNearByData() async {
        networkManager.decoder.dateDecodingStrategy = .iso8601
        
        guard let initialLocation = await locationClient.getUserLocation() else {
            return
        }
        
        do {
            let result = try await networkManager.fetch(EndPoint.searchNearBy(matching: "\(initialLocation.latitude)", lon: "\(initialLocation.longitude)"), decode: { json -> NearByRespone? in
                guard let feedResult = json as? NearByRespone else { return  nil }
                return feedResult
            })
            
            switch result {
                case .success(let res):
                    print("fetchNearByData \(res)")
                    nearByRespone = res
                case .failure(let error):
                    print("fetchNearByData error \(error)")
                    showError?(error)
            }
            
        }  catch  {
            print("fetchNearByData error \(error)")
            showError?(error as? NetworkError ?? NetworkError.unKnown)
        }
    }
}
