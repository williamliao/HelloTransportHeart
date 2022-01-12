//
//  BusJourneyCollectionViewCell.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/12.
//

import UIKit

class BusJourneyCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: BusJourneyCollectionViewCell.self)
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stopLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let localityLabel: UILabel = {
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
        timeLabel.text = ""
        stopLabel.text = ""
        localityLabel.text = ""
    }
}

extension BusJourneyCollectionViewCell {
    
    func configureView() {
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(stopLabel)
        self.contentView.addSubview(localityLabel)
        
        NSLayoutConstraint.activate([
       
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            timeLabel.heightAnchor.constraint(equalToConstant: 16),
            
            stopLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 5),
            stopLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stopLabel.heightAnchor.constraint(equalToConstant: 16),
            
            localityLabel.leadingAnchor.constraint(equalTo: stopLabel.leadingAnchor),
            localityLabel.topAnchor.constraint(equalTo: stopLabel.bottomAnchor, constant: 5),
            localityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
           
        ])
    }
    
    func configurationJourneyCell(stop: Stops) {
        timeLabel.text = stop.time
        stopLabel.text = stop.stop_name
        localityLabel.text = stop.locality
    }
}
