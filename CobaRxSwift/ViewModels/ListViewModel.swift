//
//  ListViewModel.swift
//  RxSwift
//
//  Created by Kean Nixon on 12/12/21.
//

import Foundation
import RxSwift
import RxCocoa

class ListViewModel {
    var list = BehaviorRelay<[List]>(value: [])
    
//    var list = PublishSubject<[List]>()
    
    var networkingclient = NetworkingClient()
    
    var controller: UIViewController?
    
    var listEmpty : BehaviorRelay<Bool> = BehaviorRelay(value:false)
    
    func fetchItems() {
        networkingclient.controller = controller
        
        networkingclient.setupLoadingView()
        
        networkingclient.showLoading()
        
        networkingclient.posting(Globals.getApiUrl("penjual/produk?id_account=4"), parameters: nil, requestType: Globals.HTTPRequestType.http_GET, parmheader: ["Content-type": "application/json; charset=UTF-8"]) { [self] (response, error) in
            
            if error != nil {
                Globals.showAlertWithTitle("Error Load", message: "Check koneksi internet anda!", viewController: controller!)
            } else {
                
                if response?[0]["code"] as! Int != 200 {
                    Globals.showAlertWithTitle("Error Load", message: "Check koneksi internet anda!", viewController: controller!)
                } else {
                    
                    var lists = [List]()
                    
                    for index in 0..<(response![0]["data"] as! NSArray).count {
                        
                        let dict = (response?[0]["data"]) as? NSArray
                        
                        let responsevalue = dict?[index] as? NSDictionary
                        
                        let id = responsevalue?["id_produk"] as? Int ?? 0
                        let image = responsevalue?["image"] as? String ?? ""
                        let star = responsevalue?["star"] as? Int ?? 0
                        let price = responsevalue?["price"] as? Int ?? 0
                        let description = responsevalue?["description"] as? String ?? ""
                        let sold = responsevalue?["sold"] as? Int ?? 0
                        let category = responsevalue?["category_name"] as? String ?? ""
                        let stock = responsevalue?["stock"] as? Int ?? 0
                        let name = responsevalue?["name"] as? String ?? ""
                        
                        let list = List(image: image, idProduk: id, star: star, price: price, Description: description, sold: sold, categoryName: category, stock: stock, name: name)
                        
                        lists.append(list)
                        
                    }
                    
//                    self.list.onNext(lists)
//                    self.list.onCompleted()
                    
                    self.list.accept(lists)
                    
                }
                
            }
        
            networkingclient.hideLoading()
            networkingclient.firstLoad = false
            
        }
    }
}
