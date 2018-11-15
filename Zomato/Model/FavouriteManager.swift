//
//  ZomatoFavouriteManager.swift
//  Zomato
//
//  Created by mac on 2018/10/4.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit
let ZomatoAddFavouriteNotification:NSNotification.Name = NSNotification.Name(rawValue: "ZomatoAddFavouriteNotification")
let ZomatoRemoveFavouriteNotification:NSNotification.Name = NSNotification.Name(rawValue: "ZomatoRemoveFavouriteNotification")
class ZomatoFavouriteManager: NSObject {
    private static let _manager = ZomatoFavouriteManager()
    class func manager() -> ZomatoFavouriteManager{
        return _manager
    }
    private override init() {
        favouriteIDs = UserDefaults.standard.value(forKey: kFavouriteIDs) as? [String] ?? []
        
    }
    private(set) var favouriteIDs:[String] = []
    var favouriteRestaurants:[Restaurant] = [];
    
    private let kFavouriteIDs = "kFavouriteIDs"
    func addFavourite(restaurant:Restaurant) {
        favouriteIDs.append(restaurant.id!)
        favouriteRestaurants.append(restaurant)
        UserDefaults.standard.setValue(favouriteIDs, forKey: kFavouriteIDs)
        NotificationCenter.default.post(name: ZomatoAddFavouriteNotification, object: nil, userInfo: ["restaurant":restaurant])
    }
    func removeFavourite(restaurant:Restaurant) {
        guard let id = restaurant.id else {
            return
        }
        if let index = favouriteIDs.index(of: id) {
            favouriteIDs.remove(at: index)
            favouriteRestaurants.remove(at: index)
            UserDefaults.standard.setValue(favouriteIDs, forKey: kFavouriteIDs)
            NotificationCenter.default.post(name: ZomatoRemoveFavouriteNotification, object: nil, userInfo: ["restaurant":restaurant])
        }
    }
}
