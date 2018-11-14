//
//  RestaurantCell.swift
//  Zomato
//
//  Created by mac on 2018/10/4.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    var nameLabel:UILabel!
    var addressLabel:UILabel!
    var backgroundImageView:UIImageView!
    var favouriteButton:UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        addSubview(backgroundImageView)
        addGradient()
        
        nameLabel = UILabel(frame: CGRect(x: 10, y: cellHeight - 50, width: cellWidth, height: 30))
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .white
        addSubview(nameLabel)
        
        addressLabel = UILabel(frame: CGRect(x: 10, y: cellHeight - 30, width: cellWidth, height: 30))
        addressLabel.font = UIFont.systemFont(ofSize: 10)
        addressLabel.textColor = .white
        addSubview(addressLabel)
        
        favouriteButton = UIButton(frame: CGRect(x: cellWidth - 50, y: 0, width: 50, height: 50))
        favouriteButton.setImage(UIImage(named: "icon_like"), for: .normal)
        favouriteButton.setImage(UIImage(named: "icon_liked"), for: .selected)
        addSubview(favouriteButton)
    }
    
    func addGradient() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(white: 0, alpha: 0.0).cgColor, UIColor(white: 0, alpha: 0.7).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
