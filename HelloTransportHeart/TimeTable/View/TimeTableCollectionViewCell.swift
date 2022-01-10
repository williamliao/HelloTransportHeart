//
//  TimeTableCollectionViewCell.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/10.
//

import UIKit

class TimeTableCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: TimeTableCollectionViewCell.self)
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let departureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let boundLabel: UILabel = {
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
        nameLabel.text = ""
        dateLabel.text = ""
        departureLabel.text = ""
        boundLabel.text = ""
    }
}

extension TimeTableCollectionViewCell {
    func configureView() {
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(departureLabel)
        self.contentView.addSubview(boundLabel)
        
        NSLayoutConstraint.activate([
       
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            //nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            dateLabel.heightAnchor.constraint(equalToConstant: 16),
            
            departureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            departureLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            departureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            boundLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            boundLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            boundLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
        ])
    }
    
    func configurationCell(busItem: BusItem) {
        nameLabel.text = busItem.line_name
        dateLabel.text = busItem.date
        departureLabel.text = "Arrive: \(busItem.aimed_departure_time)"
        boundLabel.text = busItem.dir
    }
}
