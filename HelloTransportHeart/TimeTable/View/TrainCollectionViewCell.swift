//
//  TrainCollectionViewCell.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/13.
//

import UIKit

class TrainCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: TrainCollectionViewCell.self)
    }
    
    let departsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let originLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let destinationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let platformLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let train_uidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        departsLabel.text = ""
        originLabel.text = ""
        destinationLabel.text = ""
        platformLabel.text = ""
        train_uidLabel.text = ""
    }
}

extension TrainCollectionViewCell {
    
    func configureView() {
        self.contentView.addSubview(departsLabel)
        self.contentView.addSubview(originLabel)
        self.contentView.addSubview(destinationLabel)
        self.contentView.addSubview(platformLabel)
        self.contentView.addSubview(train_uidLabel)
        
        NSLayoutConstraint.activate([
       
            departsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            departsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            departsLabel.heightAnchor.constraint(equalToConstant: 16),
            
            originLabel.leadingAnchor.constraint(equalTo: departsLabel.trailingAnchor, constant: 5),
            originLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            originLabel.heightAnchor.constraint(equalToConstant: 16),
            
            destinationLabel.leadingAnchor.constraint(equalTo: originLabel.leadingAnchor),
            destinationLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 5),
            destinationLabel.heightAnchor.constraint(equalToConstant: 16),
            
            platformLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            platformLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            platformLabel.heightAnchor.constraint(equalToConstant: 16),
            
            train_uidLabel.leadingAnchor.constraint(equalTo: destinationLabel.leadingAnchor),
            train_uidLabel.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 5),
            train_uidLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    func configurationTrainCell(all: All) {
        departsLabel.text = all.aimed_departure_time
        originLabel.text = "Origin: \(all.origin_name)"
        destinationLabel.text = "Destination: \(all.destination_name)"
        platformLabel.text = "Platform: \(all.platform)"
        train_uidLabel.text = "train_uid: \(all.train_uid)"
    }
}
