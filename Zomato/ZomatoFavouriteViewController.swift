

//
//  ZomatoFavouriteViewController.swift
//  Zomato
//
//  Created by mac on 2018/10/4.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit

class ZomatoFavouriteViewController: UIViewController {
    var tableView:ZomatoTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Favourite"
        self.tableView = ZomatoTableView(frame: self.view.frame)
        view.addSubview(tableView)
        tableView.restaurants = ZomatoFavouriteManager.manager().favouriteRestaurants
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(addFavourite(notification:)), name: ZomatoAddFavouriteNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeFavourite(notification:)), name: ZomatoRemoveFavouriteNotification, object: nil)
    }
    
    @objc func removeFavourite(notification:Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let rest = userInfo["restaurant"] as? ZomatoRestaurant else {
            return
        }
        guard let id = rest.id else {
            return
        }
        guard let indexPath = tableView.getIndexPathToRemove(id: id) else {
            return
        }
        self.tableView.restaurants.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
    
    @objc func addFavourite(notification:Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let rest = userInfo["restaurant"] as? ZomatoRestaurant else {
            return
        }
        self.tableView.restaurants.append(rest)
        self.tableView.reloadData()

    }
}
