//
//  ZomatoRestaurant.swift
//  Zomato
//
//  Created by mac on 2018/10/4.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit

class ZomatoRestaurant {
    var id:String!
    var aggregate_rating:String?
    var feautred_image:String?
    var address:String?
    var name:String?
    
    var location:[String: Any]?
    var user_rating:[String:Any]?
    var isFavourite = false
}
