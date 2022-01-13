//
//  NearBySearchCell.swift
//  HelloTransportHeart
//
//  Created by 雲端開發部-廖彥勛 on 2022/1/13.
//

import UIKit

class NearBySearchCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: NearBySearchCell.self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

