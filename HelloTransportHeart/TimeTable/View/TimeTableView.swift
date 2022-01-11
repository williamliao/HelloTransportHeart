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
        collectionView.dataSource = self.dataSource
        
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
    }
    
    func applyInitialSnapshots() {
        
        DispatchQueue.main.async { [weak self] in
            self?.updateSnapShot()
        }
    }
    
    func updateSnapShot() {
        
        switch viewModel.sourceType {
            case .stop:
                updateStopData()
            case .fullTime:
                updateFullTimeData()
        }
    }
    
    func updateStopData() {
        let keys = self.viewModel.stopTimeTableRespone.departures.keys.sorted()
        let array = keys.map{ self.viewModel.stopTimeTableRespone.departures[$0]!}
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, BusItem>()
        snapshot.appendSections(SectionLayoutKind.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)

        var bakerlooSnapshot = NSDiffableDataSourceSectionSnapshot<BusItem>()
        //bakerlooSnapshot.append([self.viewModel.timeTableRespone])
        
        
        array.forEach { busItem in
            bakerlooSnapshot.append(busItem)
        }
        
        dataSource.apply(bakerlooSnapshot, to: .main, animatingDifferences: false)
    }
    
    func updateFullTimeData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Stops>()
        snapshot.appendSections(SectionLayoutKind.allCases)
        fullTimeDataSource.apply(snapshot, animatingDifferences: false)

        var bakerlooSnapshot = NSDiffableDataSourceSectionSnapshot<Stops>()
        //bakerlooSnapshot.append([self.viewModel.fullTimeTableRespone.member])
        
        self.viewModel.fullTimeTableRespone.member.forEach { member in
            bakerlooSnapshot.append(member.stops)
        }
        
        fullTimeDataSource.apply(bakerlooSnapshot, to: .main, animatingDifferences: false)
    }
}
