import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class ListViewController: UIViewController, InisiateView, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var listCollection: UICollectionView!
    
    @IBOutlet weak var countCart: UILabel!
    
    @IBOutlet weak var btnCart: UIButton!
    
    weak var coordinator: MainCoordinator?
    
    private var viewModel = ListViewModel()
    
    private var bag = DisposeBag()
    
    var listCart = [ListCart]()
    
    var resCountCart = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.controller = self
        
        self.listCollection.delegate = self
        
        self.listCollection.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCollectionViewCell")
        self.listCollection.register(UINib(nibName: "NotFoundCollectionView", bundle: nil), forCellWithReuseIdentifier: "notFoundCollectionView")
        
        bindCollectionData()
        // Do any additional setup after loading the view.
    }
    
    func bindCollectionData() {
        viewModel.list.bind(to: listCollection.rx.items) { collectionView, row, model -> UICollectionViewCell in
            
            print("Hasilnya adalah", self.viewModel.list.value.count)
                if self.viewModel.list.value.count != 0 {
                    let indexPath = IndexPath.init(row: row, section: 0)
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCollectionViewCell", for: indexPath) as! ListCollectionViewCell
                    
                    cell.imgView.kf.indicatorType = .activity
                    cell.imgView.kf.setImage(with: URL(string: model.image), placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)

                    cell.lblTitle.text = model.name
                    cell.lblLocation.text = model.Description
                    cell.lblUser.text = model.categoryName

                    cell.lblPrice.text = Globals.currencyFormat(NSNumber(value:model.price))
                    
                    return cell
                } else {
                    let indexPath = IndexPath.init(row: row, section: 0)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notFoundCollectionView", for: indexPath)


                    return cell
                }
            
        }.disposed(by: bag)
        
        listCollection.rx.modelSelected(List.self).bind { list in
            let id = list.idProduk

            let valid = self.listCart.filter{ ($0.ID.contains(id)) }

            if valid.count == 0 {
                let list = ListCart(ID: "\(list.idProduk)", Qty: 1, Title: list.name, Price: "\(list.price)", LocationName: list.Description, UserName: list.categoryName, ImgUrl: list.image)

                self.listCart.append(list)

                self.resCountCart = String(self.listCart.count)

                self.updateCountCart()
            } else {
                valid[0].Qty = valid[0].Qty + 1
            }
        }.disposed(by: bag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if viewModel.networkingclient.firstLoad == true {
            return 0
        } else {
            if viewModel.list.value.count == 0 {
                return 1
            } else {
                return viewModel.list.value.count
            }
        }

    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if self.list.count == 0 {
//
//           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notFoundCollectionView", for: indexPath)
//
//
//            return cell
//
//        } else {
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCollectionViewCell", for: indexPath) as! ListCollectionViewCell
//
//            let cellinfo = self.list[indexPath.row]
//
//            cell.viewBack.corners(18)
//            cell.viewReady.corners(8)
//
//            if self.traitCollection.userInterfaceStyle == .dark {
//                // User Interface is Dark
//                cell.viewBack.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
//                cell.viewBack.layer.borderWidth = 1.5
//            } else {
//                // User Interface is Light
//                cell.viewBack.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
//                cell.viewBack.layer.borderWidth = 1.5
//            }
//
//            cell.imgView.kf.indicatorType = .activity
//            cell.imgView.kf.setImage(with: URL(string: cellinfo.ImgUrl), placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
//
//            cell.lblTitle.text = cellinfo.Title
//            cell.lblLocation.text = cellinfo.LocationName
//            cell.lblUser.text = cellinfo.UserName
//
//            if let myInteger = Int(cellinfo.Price) {
//                cell.lblPrice.text = Globals.currencyFormat(NSNumber(value:myInteger))
//            }
//
//            if cellinfo.IsAvailable == "1" {
//                cell.viewReady.isHidden = false
//            } else {
//                cell.viewReady.isHidden = true
//            }
//
//            return cell
//
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if self.list.count != 0 {
//            let cellinfo = self.list[indexPath.row]
//
//            let id = cellinfo.ID
//
//            let valid = self.listCart.filter{ ($0.ID.contains(id)) }
//
//            if valid.count == 0 {
//                let list = ListCart(ID: cellinfo.ID, Qty: 1, IsAvailable: cellinfo.IsAvailable, Title: cellinfo.Title, Price: cellinfo.Price, LocationName: cellinfo.LocationName, UserName: cellinfo.UserName, ImgUrl: cellinfo.ImgUrl, Condition : cellinfo.Condition)
//
//                self.listCart.append(list)
//
//                self.resCountCart = String(self.listCart.count)
//
//                self.updateCountCart()
//            } else {
//                valid[0].Qty = valid[0].Qty + 1
//            }
//        }
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cgsize = CGSize()
        _ = viewModel.list.subscribe {  list in
            if list.element?.count == 0 {
                    let yourWidth = CGFloat(collectionView.bounds.width)
                    let yourHeight = CGFloat(collectionView.bounds.height)

                    cgsize =  CGSize(width:yourWidth , height:yourHeight)
            } else {
                    let yourWidth = CGFloat((collectionView.bounds.width - 55 ) / 2)
                    let yourHeight = CGFloat(350)

                    cgsize = CGSize(width:yourWidth , height:yourHeight)
            }
        }.disposed(by: bag)
        
        return cgsize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 20,bottom: 0,right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }
//
    func updateCountCart() {
        if self.resCountCart != "" && self.resCountCart != "0" {
//                        badge.isHidden = false
            let digits = CGFloat( self.resCountCart.count ) // digits in the label

            if self.resCountCart.count > 2 {
                let size: CGFloat = 20
                let width = max(size, 0.7 * size * digits) // perfect circle is smallest allowed
//                badge.frame = CGRect(x: 0, y: 0, width: width, height: size)
                countCart.font = UIFont.systemFont(ofSize: 10.5)
                countCart.text = self.resCountCart
                countCart.layer.cornerRadius = size / 2
                countCart.layer.masksToBounds = true
                countCart.textAlignment = .center
                countCart.textColor = UIColor.white
                countCart.backgroundColor = UIColor.blue
            } else if self.resCountCart.count < 3 {
                let size: CGFloat = 20
                let width = max(size, 0.7 * size * digits) // perfect circle is smallest allowed
//                badge.frame = CGRect(x: 0, y: 0, width: width, height: size)
                countCart.font = UIFont.systemFont(ofSize: 10.5)
                countCart.text = self.resCountCart
                countCart.layer.cornerRadius = size / 2
                countCart.layer.masksToBounds = true
                countCart.textAlignment = .center
                countCart.textColor = UIColor.white
                countCart.backgroundColor = UIColor.blue
                countCart.addConstraint(NSLayoutConstraint(item: countCart, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20))
            }
        } else {
            countCart.isHidden = true
        }
    }
    
    @IBAction func btnCartTouched(_ sender: Any) {
        self.coordinator?.showCart(data: self.listCart)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
