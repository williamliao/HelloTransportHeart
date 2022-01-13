//
//  TimeTableViewModel.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import Foundation
import UIKit

class TimeTableViewModel {
    
    var showError: ((_ error:NetworkError) -> Void)?
    var reloadCollectionView: (() -> Void)?
    private let networkManager: NetworkManager
    var stopTimeTableRespone: StopTimeTableRespone!
    var fullTimeTableRespone: fullTimeTableRespone!
    var busJourneyResponse: BusJourneyResponse!
    var trainStationResponse: TrainStationTimetableResponse!
    var sourceType: TimeTableSource.SourceType
    
    init(networkManager: NetworkManager, sourceType: TimeTableSource.SourceType) {
        self.networkManager = networkManager
        self.sourceType = sourceType
    }
    
    func fetchStopTimeTableData(atcode: String) {

        Task {
            do {
                let result = try await networkManager.fetch(EndPoint.showStopTimeTable(matching: atcode), decode: { json -> StopTimeTableRespone? in
                    guard let feedResult = json as? StopTimeTableRespone else { return  nil }
                    return feedResult
                })
                
                switch result {
                    case .success(let res):
                       // print("fetchTimeTableData \(res)")
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
    
    func fetchFullTimeData(type: BusService.OperatorType, service: String, direction: String) {
        Task {
            do {
                let result = try await networkManager.fetch(EndPoint.showBusFullTimeTable(matching: type, service: service, direction: direction), decode: { json -> fullTimeTableRespone? in
                    guard let feedResult = json as? fullTimeTableRespone else { return  nil }
                    return feedResult
                })
                
                switch result {
                    case .success(let res):
                        //print("fetchFullTimeData \(res)")
                        fullTimeTableRespone = res
                    
                        if res.member.count > 0 {
                            goToTimeVC()
                        } else {
                            showAlert(message: "No Data From Server")
                        }
                    
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
    
    func fetchJourneyTimeData(type: BusService.OperatorType, service: String, direction: String) {
        Task {
            do {
                let result = try await networkManager.fetch(EndPoint.showBusJourneyTable(matching: type, service: service, direction: direction), decode: { json -> BusJourneyResponse? in
                    guard let feedResult = json as? BusJourneyResponse else { return  nil }
                    return feedResult
                })
                
                switch result {
                    case .success(let res):
                        print("fetchFullTimeData \(res)")
                        busJourneyResponse = res
                    
                        if res.stops.count > 0 {
                            goToTimeVC()
                        } else {
                            showAlert(message: "No Data From Server")
                        }
                    
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
    
    func fetchTrainStationTimetable(station_code: String) {
        Task {
            do {
                let result = try await networkManager.fetch(EndPoint.showTrainStationTimetable(matching: station_code), decode: { json -> TrainStationTimetableResponse? in
                    guard let feedResult = json as? TrainStationTimetableResponse else { return  nil }
                    return feedResult
                })
                
                switch result {
                    case .success(let res):
                        print("fetchTrainStationTimetable \(res)")
                        trainStationResponse = res
                    
                        if res.departures.all.count > 0 {
                            goToTimeVC()
                        } else {
                            showAlert(message: "No Data From Server")
                        }
                    
                    case .failure(let error):
                        print("fetchTrainStationTimetable error \(error)")
                        showError?(error)
                }
                
            }  catch  {
                print("fetchTrainStationTimetable error \(error)")
                showError?(error as? NetworkError ?? NetworkError.unKnown)
            }
        }
    }
    
}

extension TimeTableViewModel {
    func goToTimeVC() {
        DispatchQueue.main.async { [self] in
            let timeVC = TimeTableViewController(viewModel: self)
            presentTimeTableView(vc: timeVC)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                reloadCollectionView?()
            }
        }
    }
    
    func presentTimeTableView(vc: UIViewController) {
    
        guard let presentVC = UIApplication.shared.keyWindowPresentedController else {
            return
        }
        
        vc.modalPresentationStyle = .popover
        if let pop = vc.popoverPresentationController {
            let sheet = pop.adaptiveSheetPresentationController
            sheet.detents = [.medium(), .large()]
            
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30.0
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        presentVC.present(vc, animated: true)
    }
    
    func showAlert(message: String) {
        
        DispatchQueue.main.async {
            
            guard let presentVC = UIApplication.shared.keyWindowPresentedController else {
                return
            }
            
            let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: message, preferredStyle: .alert)
     
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { action in
                
            })
            presentVC.present(alertController, animated: true, completion: nil)
        }
    }
}
