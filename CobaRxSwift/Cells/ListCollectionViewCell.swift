import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var viewReady: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBack.corners(18)
        viewReady.corners(8)

        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            viewBack.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            viewBack.layer.borderWidth = 1.5
        } else {
            // User Interface is Light
            viewBack.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
            viewBack.layer.borderWidth = 1.5
        }
        
        // Initialization code
    }

    
    
}
