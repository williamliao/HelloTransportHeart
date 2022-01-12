//
//  PlanTableViewCell.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/12.
//

import UIKit

class PlanTableViewCell: UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: PlanTableViewCell.self)
    }
    
    let from_Point_timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let from_Point_nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
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
        from_Point_timeLabel.text = ""
        from_Point_nameLabel.text = ""
        contentLabel.text = ""
    }
}

extension PlanTableViewCell {
    func configureView() {
        self.contentView.addSubview(from_Point_timeLabel)
        self.contentView.addSubview(from_Point_nameLabel)
        self.contentView.addSubview(contentLabel)
    }
    
    func configureConstraints() {
      
        NSLayoutConstraint.activate([
            from_Point_timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            from_Point_timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            from_Point_timeLabel.heightAnchor.constraint(equalToConstant: 16),
            
            from_Point_nameLabel.leadingAnchor.constraint(equalTo: from_Point_timeLabel.trailingAnchor, constant: 5),
            from_Point_nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            from_Point_nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15),
            contentLabel.topAnchor.constraint(equalTo: from_Point_timeLabel.bottomAnchor, constant: 5),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
}

extension PlanTableViewCell {
    
    func configureCell(routes: Routes) {
        
    }
}
