import UIKit
import Kingfisher

class ListCartViewController: UIViewController, InisiateView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var listcartTable: UITableView!
    
    @IBOutlet weak var lblTotalHarga: UILabel!
    
    weak var coordinator: MainCoordinator?
    
    var listCart = [ListCart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.listcartTable.cellLayoutMarginsFollowReadableWidth = false
        self.listcartTable.delegate = self
        self.listcartTable.dataSource = self
        
        self.listcartTable.register(UINib(nibName: "ListCartTableView", bundle: nil), forCellReuseIdentifier: "listCartTableView")
        self.listcartTable.register(UINib(nibName: "NotFoundTableView", bundle: nil), forCellReuseIdentifier: "notFoundTableView")
        
        self.listcartTable.reloadData()
        
        self.totalHarga()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.listCart.count == 0 {
            return 1
        } else {
            return self.listCart.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.listCart.count == 0 {
            return tableView.frame.size.height
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.listCart.count == 0 {
            
           let cell = tableView.dequeueReusableCell(withIdentifier: "notFoundTableView", for: indexPath)
            
           return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCartTableView", for: indexPath) as! ListCartTableView
            
            let cellinfo = self.listCart[indexPath.row]
            
            cell.viewBack.corners(18)
            
            cell.imgView.corners(18)
            
            if self.traitCollection.userInterfaceStyle == .dark {
                // User Interface is Dark
                cell.viewBack.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
                cell.viewBack.layer.borderWidth = 1.5
            } else {
                // User Interface is Light
                cell.viewBack.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
                cell.viewBack.layer.borderWidth = 1.5
            }
            
            cell.imgView.kf.indicatorType = .activity
            cell.imgView.kf.setImage(with: URL(string: cellinfo.ImgUrl), placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
            
            cell.lblTitle.text = cellinfo.Title
            
            if let myInteger = Int(cellinfo.Price) {
                cell.lblPrice.text = Globals.currencyFormat(NSNumber(value:myInteger))
            }
            
            if cell.txtQty.text == "0" {
                cell.txtQty.text = String(cellinfo.Qty)
            }
            
            cell.didPlus { (qty) in
                cellinfo.Qty = qty
                self.totalHarga()
            }
            
            cell.didMinus { (qty) in
                cellinfo.Qty = qty
                self.totalHarga()
            }
            
            cell.didEdit { (qty) in
                cellinfo.Qty = qty
                self.totalHarga()
            }
            
            return cell
            
        }
        
    }
    
    @IBAction func btnBackTouched(_ sender: Any) {
        self.coordinator?.dismiss()
    }
    
    func totalHarga() {
        var totalharga = 0
        for index in 0..<self.listCart.count {
            totalharga += (Int(self.listCart[index].Qty) * Int(self.listCart[index].Price)!)
        }
        
        self.lblTotalHarga.text = Globals.currencyFormat(NSNumber(value:totalharga))
    }
    
}

extension ListCartViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
