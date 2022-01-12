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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let to_Point_timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let baseStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let contentFrom_PointStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        to_Point_timeLabel.text = ""
    }
}

extension PlanTableViewCell {
    func configureView() {
        self.contentView.addSubview(from_Point_timeLabel)
        self.contentView.addSubview(to_Point_timeLabel)
        self.contentView.addSubview(baseStackView)
    
        baseStackView.addArrangedSubview(contentFrom_PointStackView)
    }
    
    func configureConstraints() {
      
        NSLayoutConstraint.activate([
            from_Point_timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            from_Point_timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            from_Point_timeLabel.heightAnchor.constraint(equalToConstant: 16),
            
            //to_Point_timeLabel.leadingAnchor.constraint(equalTo: from_Point_timeLabel.trailingAnchor, constant: 5),
            to_Point_timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            to_Point_timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            to_Point_timeLabel.heightAnchor.constraint(equalToConstant: 16),

            baseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            baseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            baseStackView.topAnchor.constraint(equalTo: from_Point_timeLabel.bottomAnchor, constant: 5),
            baseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
}

extension PlanTableViewCell {
    
    func configureCell(routes: Routes) {
        from_Point_timeLabel.text = routes.duration
        
        to_Point_timeLabel.text = "\(routes.departure_time)" + " - " + "\(routes.arrival_time)"
   
        for index in 0...routes.route_parts.count-1 {
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            
            let label = createLabel()
            label.backgroundColor = .systemRed
            label.text = "\(routes.route_parts[index].departure_time) " + "\(routes.route_parts[index].from_point_name)"
            backgroundView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 0),
                label.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: 0),
                
                label.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
                label.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0),
            ])
            contentFrom_PointStackView.addArrangedSubview(backgroundView)
            
            if let steps = routes.route_parts[index].steps, steps.count > 0 {
                for index2 in 0...steps.count-1 {
                    let label = createLabel()
                    let d = steps[index2].duration
                    let duration = String(d.dropFirst(3))
                    label.text = "\(steps[index2].instruction.text) For \(duration) Walk"
                    contentFrom_PointStackView.addArrangedSubview(label)
                }
            } else {
                let label = createLabel()
                label.text = "Bus \(routes.route_parts[index].line_name) For \(routes.route_parts[index].duration)"
                contentFrom_PointStackView.addArrangedSubview(label)
            }
        }
        
        let label = createLabel()
        label.text = "\(routes.arrival_time) Destination"
        contentFrom_PointStackView.addArrangedSubview(label)
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
