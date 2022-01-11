//
//  BusServiceCell.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/11.
//

import UIKit

class BusServiceCell: UITableViewCell {
    
    var onInBoundAction: (() -> Void)?
    var onOutBoundAction: (() -> Void)?
   
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
    
    let inBoundButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .systemGreen
        configuration.baseForegroundColor = .label
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(inBoundOnTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let outBoundButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .systemGreen
        configuration.baseForegroundColor = .label
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(outBoundOnTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        inBoundButton.setTitle("", for: .normal)
        outBoundButton.setTitle("", for: .normal)
        inBoundButton.isHidden = false
        outBoundButton.isHidden = false
    }
}

extension BusServiceCell {
    func configureView() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(inBoundButton)
        self.contentView.addSubview(outBoundButton)
    }
    
    func configureConstraints() {
      
        NSLayoutConstraint.activate([
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            inBoundButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            inBoundButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
            outBoundButton.leadingAnchor.constraint(equalTo: inBoundButton.leadingAnchor),
            outBoundButton.topAnchor.constraint(equalTo: inBoundButton.bottomAnchor, constant: 5),
            outBoundButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
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
                inBoundButton.setTitle("\(boundType)\(bound)", for: .normal)
            } else{
                outBoundButton.setTitle("\(boundType)\(bound)", for: .normal)
            }
        }
        
        if inBoundButton.currentTitle == nil || inBoundButton.currentTitle == "" {
            inBoundButton.isHidden = true
        }
        
        if outBoundButton.currentTitle == nil || outBoundButton.currentTitle == "" {
            outBoundButton.isHidden = true
        }
    }
}

extension BusServiceCell {
    @objc private func inBoundOnTap() {
        onInBoundAction?()
    }
    
    @objc private func outBoundOnTap() {
        onOutBoundAction?()
    }
}
