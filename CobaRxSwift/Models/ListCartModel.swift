import Foundation

class ListCart {
    var ID: String
    var Qty: Int
    var Title: String
    var Price: String
    var LocationName: String
    var UserName : String
    var ImgUrl : String
    
    init(ID: String, Qty: Int, Title: String, Price: String, LocationName: String, UserName: String, ImgUrl: String){
        self.ID = ID
        self.Qty = Qty
        self.Title = Title
        self.Price = Price
        self.LocationName = LocationName
        self.UserName = UserName
        self.ImgUrl = ImgUrl
    }
}
