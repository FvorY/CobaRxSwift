import UIKit

class ListCartTableView: UITableViewCell, UITextFieldDelegate {
    
    var index = 0
    
    var isPlus: ((_ result: Int) -> ())? = nil
    
    func didPlus(completed: @escaping(_ result: Int) -> ()) {
        self.isPlus = completed
    }
    
    var isMinus: ((_ result: Int) -> ())? = nil
    
    func didMinus(completed: @escaping(_ result: Int) -> ()) {
        self.isMinus = completed
    }
    
    var isEdit: ((_ result: Int) -> ())? = nil
    
    func didEdit(completed: @escaping(_ result: Int) -> ()) {
        self.isEdit = completed
    }
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblKondisi: UILabel!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtQty.delegate = self

        // Initialization code
    }

    @IBAction func plusTouched(_ sender: Any) {
        
        let qty = self.txtQty.text!
        if let intqty = Int(qty) {
            self.txtQty.text = String(intqty + 1)
            
            if let completed = isPlus {
                completed(intqty + 1)
            }
        }
        
    }
    
    @IBAction func minusTouched(_ sender: Any) {
        
        let qty = self.txtQty.text!
        if let intqty = Int(qty) {
            if (intqty - 1) > 0 {
                self.txtQty.text = String(intqty - 1)
                
                if let completed = isMinus {
                    completed(intqty - 1)
                }
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == txtQty {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let qty = self.txtQty.text!
        if let intqty = Int(qty) {
            
            if intqty == 0 {
                self.txtQty.text = "1"
            } else {
                self.txtQty.text = "\(intqty)"
            }
            
            if let completed = isEdit {
                if let res = Int(self.txtQty.text!) {
                    completed(res)
                }
            }
            
        }
    }
    
}
