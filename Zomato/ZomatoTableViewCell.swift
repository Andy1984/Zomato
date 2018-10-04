//
//  ZomatoTableViewCell.swift
//  Zomato
//
//  Created by mac on 2018/10/4.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit

class ZomatoTableViewCell: UITableViewCell {
    var nameLabel:UILabel!
    var addressLabel:UILabel!
    var backgroundImageView:UIImageView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel = UILabel(frame: CGRect(x: 10, y: cellHeight - 50, width: cellWidth, height: 30))
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .white
        
        addressLabel = UILabel(frame: CGRect(x: 10, y: cellHeight - 30, width: cellWidth, height: 30))
        addressLabel.font = UIFont.systemFont(ofSize: 10)
        addressLabel.textColor = .white
        
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        addSubview(backgroundImageView)
        addSubview(nameLabel)
        addSubview(addressLabel)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
