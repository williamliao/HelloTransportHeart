//
//  StatusView.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import UIKit

class StatusView: UIView {
    
    enum SectionLayoutKind: Int, CaseIterable, Hashable {
        case bakerloo
    }
    
    private let viewModel: StatusViewModel
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, LinesItem>! = nil
    
    
    
    init(viewModel: StatusViewModel) {
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
       
        let configuredBakerlooCell = UICollectionView.CellRegistration<UICollectionViewListCell, LinesItem> { (cell, indexPath, itemIdentifier) in
            
            var contentConfiguration = UIListContentConfiguration.valueCell()
            
            contentConfiguration.text = itemIdentifier.friendly_name
            contentConfiguration.secondaryText = itemIdentifier.status
            
            contentConfiguration.textProperties.color = .label
            contentConfiguration.secondaryTextProperties.color = .systemGreen

            cell.contentConfiguration = contentConfiguration
        }

        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, LinesItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: LinesItem) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: configuredBakerlooCell, for: indexPath, item: identifier)
        }
    }
    
    func applyInitialSnapshots() {
        
        DispatchQueue.main.async { [weak self] in
            self?.updateSnapShot()
        }
    }
    
    func updateSnapShot() {
        
        let line = self.viewModel.respone.lines
        var item = [LinesItem]()
        
        item.append(LinesItem(friendly_name: line.bakerloo.friendly_name, status: line.bakerloo.status))
        item.append(LinesItem(friendly_name: line.central.friendly_name, status: line.central.status))
        item.append(LinesItem(friendly_name: line.circle.friendly_name, status: line.circle.status))
        item.append(LinesItem(friendly_name: line.district.friendly_name, status: line.district.status))
        item.append(LinesItem(friendly_name: line.dlr.friendly_name, status: line.dlr.status))
        item.append(LinesItem(friendly_name: line.hammersmith.friendly_name, status: line.hammersmith.status))
        item.append(LinesItem(friendly_name: line.jubilee.friendly_name, status: line.jubilee.status))
        item.append(LinesItem(friendly_name: line.metropolitan.friendly_name, status: line.metropolitan.status))
        item.append(LinesItem(friendly_name: line.northern.friendly_name, status: line.northern.status))
        item.append(LinesItem(friendly_name: line.piccadilly.friendly_name, status: line.piccadilly.status))
        item.append(LinesItem(friendly_name: line.victoria.friendly_name, status: line.victoria.status))
        item.append(LinesItem(friendly_name: line.waterlooandcity.friendly_name, status: line.waterlooandcity.status))
        
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, LinesItem>()
        snapshot.appendSections(SectionLayoutKind.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)

        var bakerlooSnapshot = NSDiffableDataSourceSectionSnapshot<LinesItem>()
        bakerlooSnapshot.append(item)
        dataSource.apply(bakerlooSnapshot, to: .bakerloo, animatingDifferences: false)
    }
}
