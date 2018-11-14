//
//  ViewController.swift
//  Zomato
//
//  Created by mac on 2018/10/4.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit




class BestViewController: UIViewController {
    var tableView:RestaurantTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = RestaurantTableView(frame: self.view.frame)
        view.addSubview(tableView)
        let manager = ZomatoHttpManager()
        //http request and cache
        manager.request(handle: { (restaurants) in
            self.tableView.restaurants = restaurants
            self.tableView.reloadData();
        })
        
        title = "Abbotsford"
        NotificationCenter.default.addObserver(self, selector: #selector(addFavourite(notification:)), name: ZomatoAddFavouriteNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeFavourite(notification:)), name: ZomatoRemoveFavouriteNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func removeFavourite(notification:Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let rest = userInfo["restaurant"] as? Restaurant else {
            return
        }
        guard let id = rest.id else {
            return
        }
        guard let indexPath = tableView.getIndexPathToRemove(id: id) else {
            return
        }

        let cell = self.tableView.tableView.cellForRow(at: indexPath as IndexPath)
        guard let zCell = cell as? RestaurantCell else {
            return
        }
        zCell.favouriteButton.isSelected = false
        
    }
    
    @objc func addFavourite(notification:Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let rest = userInfo["restaurant"] as? Restaurant else {
            return
        }
        guard let indexPath = tableView.getIndexPathToRemove(id: rest.id) else {
            return
        }
        guard let cell = self.tableView.tableView.cellForRow(at: indexPath as IndexPath) as? RestaurantCell else {
            return
        }
        cell.favouriteButton.isSelected = true
    }
    


}

