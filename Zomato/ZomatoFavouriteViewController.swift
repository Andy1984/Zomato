

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
    }

}
