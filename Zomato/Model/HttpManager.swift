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
import SwiftyJSON

let melbourneID = 259
let abbotsfordEntityID = 98284
let userKey = "0017c80f7b577868dce86c940250eeaa"
let abbotsfordEntityType = "subzone"
let basicURLString = "https://developers.zomato.com/api/v2.1"
let bestRestaurantCache = "bestRestaurantCache"

class HttpManager: NSObject {
    func request(handle:@escaping ([Restaurant])->()) {
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
    
    func handleResultDict(_ resultDict:[String : Any], handle:([Restaurant])->()) {
        //Favourite
        let favouriteIDs = FavouriteManager.manager().favouriteIDs
        let json = JSON(resultDict)
        let bestRatedRestaurantsDictionaryArray = json["best_rated_restaurant"].arrayValue
        var restaurants:[Restaurant] = []
        for dictValue in bestRatedRestaurantsDictionaryArray {
            let dict = dictValue["restaurant"].dictionaryObject
            if let rest = Restaurant.deserialize(from: dict), rest.id != nil, rest.id != "" {
                if favouriteIDs.contains(rest.id!) {
                    rest.isFavourite = true
                    FavouriteManager.manager().favouriteRestaurants.append(rest)
                }
                restaurants.append(rest)
            }
        }
        handle(restaurants)
    }
}
