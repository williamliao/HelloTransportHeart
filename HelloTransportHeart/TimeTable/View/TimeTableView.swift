//
//  TimeTableView.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import UIKit

class TimeTableView: UIView {
    enum SectionLayoutKind: Int, CaseIterable, Hashable {
        case main
    }
    
    private let viewModel: TimeTableViewModel
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, BusItem>! = nil
    private var fullTimeDataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Stops>! = nil
    private var journeyDataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Stops>! = nil
    
    init(viewModel: TimeTableViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureHierarchy()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.applyInitialSnapshots()
            }
        }
    }
    
    func configureLayout() -> UICollectionViewLayout {
        let provider = {(_: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            return .list(using: configuration, layoutEnvironment: layoutEnv)
        }
        return UICollectionViewCompositionalLayout(sectionProvider: provider)
    }
    
    func configureDataSource() {
       
        let configuredMainCell = UICollectionView.CellRegistration<TimeTableCollectionViewCell, BusItem> { (cell, indexPath, itemIdentifier) in
        
          /*  var contentConfiguration = UIListContentConfiguration.valueCell()
            
            contentConfiguration.text = itemIdentifier.line_name
            
            
            //let keys = itemIdentifier.departures.keys.sorted()
           // let array = keys.map{ itemIdentifier.departures[$0]!}
           // let busItem = array[indexPath.row]
           // let direction = busItem[indexPath.row].direction
            
            contentConfiguration.secondaryText = itemIdentifier.date
            
            contentConfiguration.textProperties.color = .label
            contentConfiguration.secondaryTextProperties.color = .systemGreen

            cell.contentConfiguration = contentConfiguration */
            
            cell.configurationCell(busItem: itemIdentifier)
        }
        
        let configuredFullTimeCell = UICollectionView.CellRegistration<TimeTableCollectionViewCell, Stops> { (cell, indexPath, itemIdentifier) in
            cell.configurationCell(stop: itemIdentifier)
        }
        
        let journeyCell = UICollectionView.CellRegistration<BusJourneyCollectionViewCell, Stops> { (cell, indexPath, itemIdentifier) in
            cell.configurationJourneyCell(stop: itemIdentifier)
        }

        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, BusItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: BusItem) -> TimeTableCollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: configuredMainCell, for: indexPath, item: identifier)
        }
        
        fullTimeDataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Stops>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Stops) -> TimeTableCollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: configuredFullTimeCell, for: indexPath, item: identifier)
        }
        
        journeyDataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Stops>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Stops) -> BusJourneyCollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: journeyCell, for: indexPath, item: identifier)
        }
        
    }
    
    func applyInitialSnapshots() {
        
        DispatchQueue.main.async { [self] in
            updateSnapShot()
        }
    }
    
    func updateSnapShot() {
        
        switch viewModel.sourceType {
            case .stop:
                updateStopData()
            case .fullTime:
                updateFullTimeData()
            case .detail:
                updateJourneyData()
        }
    }
    
    func updateStopData() {
        
        collectionView.dataSource = dataSource
        
        let keys = self.viewModel.stopTimeTableRespone.departures.keys.sorted()
        let departures = keys.map{ viewModel.stopTimeTableRespone.departures[$0]!}
      
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, BusItem>()
        snapshot.appendSections(SectionLayoutKind.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)

        var mainSnapshot = NSDiffableDataSourceSectionSnapshot<BusItem>()
 
        departures.forEach { busItem in
            mainSnapshot.append(busItem)
        }
        
        dataSource.apply(mainSnapshot, to: .main, animatingDifferences: false)
    }
    
    func updateFullTimeData() {
        
        collectionView.dataSource = fullTimeDataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Stops>()
        snapshot.appendSections(SectionLayoutKind.allCases)
        fullTimeDataSource.apply(snapshot, animatingDifferences: false)

        var mainSnapshot = NSDiffableDataSourceSectionSnapshot<Stops>()
        
        viewModel.fullTimeTableRespone.member.forEach { member in
            mainSnapshot.append(member.stops)
        }
        
        fullTimeDataSource.apply(mainSnapshot, to: .main, animatingDifferences: false)
    }
    
    func updateJourneyData() {
        
        collectionView.dataSource = journeyDataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Stops>()
        snapshot.appendSections(SectionLayoutKind.allCases)
        journeyDataSource.apply(snapshot, animatingDifferences: false)

        var mainSnapshot = NSDiffableDataSourceSectionSnapshot<Stops>()
        mainSnapshot.append(viewModel.busJourneyResponse.stops)
        
        journeyDataSource.apply(mainSnapshot, to: .main, animatingDifferences: false)
    }
}
