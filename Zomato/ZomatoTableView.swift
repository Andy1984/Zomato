//
//  ZomatoTableView.swift
//  Zomato
//
//  Created by mac on 2018/10/4.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SDWebImage
let cellWidth = UIScreen.main.bounds.size.width
let cellHeight = cellWidth * 9.0 / 16.0
class ZomatoTableView: UIView, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource {
    var restaurants:[ZomatoRestaurant] = []
    var tableView:UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        //创建tableView
        tableView = UITableView(frame: self.frame, style: .plain)
        self.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ZomatoTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.rowHeight = cellHeight
        tableView.allowsSelection = false
        tableView.emptyDataSetSource = self
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString:NSAttributedString = NSAttributedString(string: "No favourite")
        return attributeString
    }
    
    
    func getIndexPathToRemove(id:String) -> NSIndexPath? {
        for i in 0 ..< self.restaurants.count {
            if self.restaurants[i].id == id {
                let indexPath = IndexPath(row: i, section: 0)
                return indexPath as NSIndexPath
            }
        }
        return nil
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ZomatoTableViewCell
        let rest = self.restaurants[indexPath.row]
        cell.nameLabel.text = rest.name
        cell.addressLabel.text = rest.address
        cell.favouriteButton.tag = indexPath.row
        cell.favouriteButton.isSelected = rest.isFavourite
        if let url = URL(string: rest.feautred_image!) {
            let option = SDWebImageOptions(rawValue: 0)
            cell.backgroundImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "carousel_placeholder"), options: option, completed: nil)
        } else {
            cell.backgroundImageView.image = nil
        }
        cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonClicked), for: .touchUpInside)
        return cell
    }
    
    @objc func favouriteButtonClicked(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        let rest = self.restaurants[sender.tag]
        rest.isFavourite = sender.isSelected
        if rest.isFavourite {
            ZomatoFavouriteManager.manager().addFavourite(restaurant: rest)
        } else {
            ZomatoFavouriteManager.manager().removeFavourite(restaurant: rest)
        }
        
    }

}
