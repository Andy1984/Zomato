//
//  ZomatoHttpManager.swift
//  Zomato
//
//  Created by mac on 2018/10/23.
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

class ZomatoHttpManager: NSObject {
    func request(handle:@escaping ([ZomatoRestaurant])->()) {
        let URLString = basicURLString + "/location_details"
        let params = ["entity_id":abbotsfordEntityID,
                      "entity_type":abbotsfordEntityType,
                      ] as [String : Any];
        Alamofire.request(URLString, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["user-key":userKey]).responseJSON { (response) in
            guard let resultDict = response.result.value as? [String : Any] else {
                if let oldResultDict = UserDefaults.standard.value(forKey: bestRestaurantCache) as? [String:Any] {
                    self.handleResultDict(oldResultDict, handle: handle)
                }
                return
            }
            //Save the whole dictionary
            UserDefaults.standard.setValue(resultDict, forKey: bestRestaurantCache)
            self.handleResultDict(resultDict, handle: handle)
        }
    }
    
    func handleResultDict(_ resultDict:[String : Any], handle:([ZomatoRestaurant])->()) {
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
        handle(rests);
    }
}
