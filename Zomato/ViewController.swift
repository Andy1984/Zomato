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
let cellWidth = UIScreen.main.bounds.size.width
let cellHeight = cellWidth * 9.0 / 16.0
var bestRestaurantCache = "bestRestaurantCache"

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var tableView:UITableView!
    var restaurants:[ZomatoRestaurant] = []
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
            if (rest.aggregate_rating != nil) {
                rests.append(rest)
            }
        }
        rests.sort(by: { (restA, restB) -> Bool in
            let floatA:Float! = Float(restA.aggregate_rating!)
            let floatB:Float! = Float(restB.aggregate_rating!)
            return floatA > floatB;
        })
        
        self.restaurants = rests;
        //刷新数据
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request()
        title = "Abbotsford"
        //创建tableView
        tableView = UITableView(frame: self.view.frame, style: .plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ZomatoTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.rowHeight = cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //十个最佳
        if self.restaurants.count > 10 {
            return 10;
        }
        return self.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ZomatoTableViewCell
        let rest = self.restaurants[indexPath.row]
        cell.nameLabel.text = rest.name
        cell.addressLabel.text = rest.address
        if rest.feautred_image != nil {
            let url = URL(string: rest.feautred_image!)
            cell.backgroundImageView?.sd_setImage(with: url, completed: nil)
        } else {
            cell.backgroundImageView.image = nil
        }
        
        return cell
    }
    




}

