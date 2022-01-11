//
//  BusServiceCell.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/11.
//

import UIKit

class BusServiceCell: UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: BusServiceCell.self)
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let inBoundLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let outBoundLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        inBoundLabel.text = ""
        outBoundLabel.text = ""
    }
}

extension BusServiceCell {
    func configureView() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(inBoundLabel)
        self.contentView.addSubview(outBoundLabel)
    }
    
    func configureConstraints() {
      
        NSLayoutConstraint.activate([
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            inBoundLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            inBoundLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            inBoundLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            inBoundLabel.heightAnchor.constraint(equalToConstant: 16),
            
            outBoundLabel.leadingAnchor.constraint(equalTo: inBoundLabel.leadingAnchor),
            outBoundLabel.topAnchor.constraint(equalTo: inBoundLabel.bottomAnchor, constant: 5),
            outBoundLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            outBoundLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }
}

extension BusServiceCell {
    
    func configureCell(member: BusMember) {

        nameLabel.text = "\(member.operators.name): \(member.line_name)"
        
        var bound = ""
        var boundType = ""
        
        for direction in member.directions {
            bound = " to \(direction.destination.description)"
            boundType = "\(direction.name):"
            
            if boundType == "inbound:" {
                inBoundLabel.text = "\(boundType)\(bound)"
            } else{
                outBoundLabel.text = "\(boundType)\(bound)"
            }
        }
    }
}
