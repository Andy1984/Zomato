//
//  ViewController.swift
//  Zomato
//
//  Created by mac on 2018/10/4.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

var melbourneID = 259
var abbotsfordEntityID = 98284
let userKey = "0017c80f7b577868dce86c940250eeaa"
let abbotsfordEntityType = "subzone"
let basicURLString = "https://developers.zomato.com/api/v2.1"
var bestRestaurantCache = "bestRestaurantCache"

class ZomatoBestViewController: UIViewController {
    var tableView:ZomatoTableView!
    //发起网络请求
    func request() {
        let URLString = basicURLString + "/location_details"
        let params = ["entity_id":abbotsfordEntityID,
                      "entity_type":abbotsfordEntityType,
                      ] as [String : Any];
        Alamofire.request(URLString, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["user-key":userKey]).responseJSON { (response) in
            guard let resultDict = response.result.value as? [String : Any] else {
                if let oldResultDict = UserDefaults.standard.value(forKey: bestRestaurantCache) as? [String:Any] {
                    self.handleResultDict(oldResultDict)
                }
                return
            }
            
            //把整个存起来
            UserDefaults.standard.setValue(resultDict, forKey: bestRestaurantCache)
            self.handleResultDict(resultDict)
        }
    }
    
    func handleResultDict(_ resultDict:[String : Any]) {
        let bestRatedRestaurants:[[String:Any]] = resultDict["best_rated_restaurant"] as! [[String : Any]]
        var rests:[ZomatoRestaurant] = [];
        for dict in bestRatedRestaurants {
            let info = dict["restaurant"] as! [String: Any]
            let rest = ZomatoRestaurant()
            rest.user_rating = info["user_rating"] as? [String:Any]
            rest.aggregate_rating = rest.user_rating?["aggregate_rating"] as? String
            rest.feautred_image = info["featured_image"] as? String
            rest.location = info["location"] as? [String: Any]
            rest.address = rest.location?["address"] as? String
            rest.name = info["name"] as? String
            rest.id = info["id"] as? String
            if (rest.aggregate_rating != nil) {
                rests.append(rest)
            }
        }
        //Favourite
        let favouriteIDs = ZomatoFavouriteManager.manager().favouriteIDs
        for rest in rests {
            if favouriteIDs.contains(rest.id) {
                rest.isFavourite = true
                ZomatoFavouriteManager.manager().favouriteRestaurants.append(rest)
            }
        }
        //ReloadData
        self.tableView.restaurants = rests;
        self.tableView.reloadData();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = ZomatoTableView(frame: self.view.frame)
        view.addSubview(tableView)
        request()
        title = "Abbotsford"
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

        let cell = self.tableView.tableView.cellForRow(at: indexPath as IndexPath)
        guard let zCell = cell as? ZomatoTableViewCell else {
            return
        }
        zCell.favouriteButton.isSelected = false
        
    }
    
    @objc func addFavourite(notification:Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let rest = userInfo["restaurant"] as? ZomatoRestaurant else {
            return
        }
        guard let indexPath = tableView.getIndexPathToRemove(id: rest.id) else {
            return
        }
        guard let cell = self.tableView.tableView.cellForRow(at: indexPath as IndexPath) as? ZomatoTableViewCell else {
            return
        }
        cell.favouriteButton.isSelected = true
    }
    


}

