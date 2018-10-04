//
//  ZomatoFavouriteManager.swift
//  Zomato
//
//  Created by mac on 2018/10/4.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit

class ZomatoFavouriteManager: NSObject {
    private static let _manager = ZomatoFavouriteManager()
    class func manager() -> ZomatoFavouriteManager{
        return _manager
    }
    private override init() {
        favouriteIDs = UserDefaults.standard.value(forKey: kFavouriteIDs) as? [String] ?? []
    }
    private(set) var favouriteIDs:[String] = []
    private let kFavouriteIDs = "kFavouriteIDs"
    func addFavourite(id:String) {
        favouriteIDs.append(id)
        UserDefaults.standard.setValue(favouriteIDs, forKey: kFavouriteIDs)
    }
    func removeFavourite(id:String) {
        if let index = favouriteIDs.index(of: id) {
            favouriteIDs.remove(at: index)
        }
        UserDefaults.standard.setValue(favouriteIDs, forKey: kFavouriteIDs)
    }
    
  
    
    
}
