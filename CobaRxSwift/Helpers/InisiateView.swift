import Foundation
import UIKit

protocol InisiateView {
    static func instantiate() -> Self
    static func instantiateXib() -> Self
}

extension InisiateView where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
         
    }
    
    static func instantiateXib() -> Self {
        return Self(nibName: String(describing: self), bundle: nil) 
    }
}
