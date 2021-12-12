import Foundation

class List: Codable {
    let image: String
    let idProduk: String
    let star, price: Int
    let Description: String
    let sold: Int
    let categoryName: String
    let stock: Int
    let name: String

    init(image: String, idProduk: Int, star: Int, price: Int, Description: String, sold: Int, categoryName: String, stock: Int, name: String) {
        self.image = Globals.getImgUrl(image)
        self.idProduk = "\(idProduk)"
        self.star = star
        self.price = price
        self.Description = Description
        self.sold = sold
        self.categoryName = categoryName
        self.stock = stock
        self.name = name
    }
}
