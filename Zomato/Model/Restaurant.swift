import HandyJSON
class Restaurant: HandyJSON {
    required init() {}
    var id:String?
    var featured_image:String?
    var name:String?
    var location:Location?
    var user_rating:UserRating?
    
    var isFavourite = false
}

class UserRating: HandyJSON {
    required init() {}
    var aggregate_rating:String?
    var rating_text:String?
    var rating_color:String?
    var votes:String?
}

class Location: HandyJSON {
    required init() {}
    var address:String?
    var locality:String?
    var city:String?
    var latitude:String?
    var longitude:String?
    var zipcode:String?
    var country_id:String?
}



