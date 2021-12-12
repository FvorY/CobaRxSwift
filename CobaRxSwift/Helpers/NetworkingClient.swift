import Foundation
import Alamofire

class NetworkingClient {
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    var firstLoad = true
    var loadingView: UIView?
    var controller: UIViewController?
    
    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
        Alamofire.request(url).validate().responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            } else if let jsonArray = response.result.value as? [[String: Any]] {
                completion(jsonArray, nil)
            } else if let jsonDict = response.result.value as? [String: Any] {
                completion([jsonDict], nil)
            }
        }
    }
    
    func posting(_ url: URL, parameters: [String: Any]?, requestType: Globals.HTTPRequestType, parmheader: [String: String]?,  completion: @escaping WebServiceResponse) {
        if requestType == Globals.HTTPRequestType.http_GET {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: parmheader).responseJSON { response in
                
                if let error = response.error {
                    completion(nil, error)
                } else if let jsonArray = response.result.value as? [[String: Any]] {
                    completion(jsonArray, nil)
                } else if let jsonDict = response.result.value as? [String: Any] {
                    completion([jsonDict], nil)
                }

            }
        } else {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: parmheader).responseJSON { response in
                
                if let error = response.error {
                    completion(nil, error)
                } else if let jsonArray = response.result.value as? [[String: Any]] {
                    completion(jsonArray, nil)
                } else if let jsonDict = response.result.value as? [String: Any] {
                    completion([jsonDict], nil)
                }

            }
        }
    }
    
    func setupLoadingView() {
        let width:CGFloat = 60.0
        let height: CGFloat = 60.0
        
        loadingView = UIView()
//        loadingView.autoresizingMask = UIViewAutoresizing.None
        loadingView?.translatesAutoresizingMaskIntoConstraints = false
        
//        loadingView.frame = CGRectMake((self.view.frame.size.width - width) / 2, (self.view.frame.size.height - height) / 2, width, height)
        
        loadingView?.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
        loadingView?.alpha = 0.7
        loadingView?.layer.cornerRadius = 8.0
        controller?.view.addSubview(loadingView!)
        
        controller?.view.addConstraint(NSLayoutConstraint(
            item: loadingView,
            attribute: NSLayoutConstraint.Attribute.width,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: width
        ))
        
        controller?.view.addConstraint(NSLayoutConstraint(
            item: loadingView,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: height
            ))
        
        controller?.view.addConstraint(NSLayoutConstraint(
            item: loadingView,
            attribute: NSLayoutConstraint.Attribute.centerX,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: controller?.view,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1,
            constant: 0
            ))
        
        controller?.view.addConstraint(NSLayoutConstraint(
            item: loadingView,
            attribute: NSLayoutConstraint.Attribute.centerY,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: controller?.view,
            attribute: NSLayoutConstraint.Attribute.centerY,
            multiplier: 1,
            constant: 0
            ))
        
        let loadingProcess: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        loadingProcess.style = UIActivityIndicatorView.Style.large
        loadingProcess.color = UIColor(red: 107/255, green: 107/255, blue: 107/255, alpha: 1.0)
        loadingProcess.startAnimating()
        loadingView?.addSubview(loadingProcess)
        
        loadingView?.isHidden = true
    }
    
    func showLoading() {
        if loadingView != nil {
            loadingView?.isHidden = false;
            controller?.view.bringSubviewToFront(loadingView!)
        }
    }
//
    func hideLoading() {
        if loadingView != nil {
            loadingView?.isHidden = true
            controller?.view.sendSubviewToBack(loadingView!)
        }
    }
    
    func isLoading() -> Bool {
        if loadingView != nil {
            return loadingView!.isHidden ? false : true
        }
        return false
    }
    
}
    

