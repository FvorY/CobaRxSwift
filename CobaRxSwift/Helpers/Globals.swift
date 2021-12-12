import UIKit

class Globals: NSObject {
    
    enum HTTPRequestType {
        case http_POST
        case http_GET
    }
    
    override init() {
        
    }
    
    static func showAlertWithTitle(_ title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    static func showConfirmAlertWithTitle(_ title: String, message: String, viewController: UIViewController, completion:((_ action:UIAlertAction?) -> Void)?) {
        //        var alert:UIAlertView = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: "NO", otherButtonTitles: "YES", nil)
        //        alert.show()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: completion))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func currencyFormat(_ number: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        //        numberFormatter.currencySymbol = "\(Globals.getDataSetting("currencyName") as! String) "
        numberFormatter.currencySymbol = "Rp "
        numberFormatter.currencyGroupingSeparator = "."
        numberFormatter.currencyDecimalSeparator = ","
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: number)!
    }
    
    static func getApiUrl(_ api: String) -> URL {
        return URL(string: String(format: "%@%@", self.getApiBaseUrl(), api))!
    }
    
    static func getApiBaseUrl() -> String {
        return "http://127.0.0.1/iwak/api/"
    }
    
    static func getImgUrl(_ api: String) -> String {
        return String(format: "%@%@", self.getImgBaseUrl(), api)
    }
    
    static func getImgBaseUrl() -> String {
        return "http://127.0.0.1/iwak/"
    }
    
    static func suffixNumber(_ number:NSNumber) -> String {
        
        var num:Double = number.doubleValue;
        let sign = ((num < 0) ? "-" : "" );
        
        num = fabs(num);
        
        if (num < 1000.0){
            return "\(sign)\(num)";
        }
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = ["K","M","G","T","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])";
    }
    
    
    static func shortNumberFormat(_ number: NSNumber) -> String {
        var units = ["", "K", "M", "B"]
        var iUnit = 0
        var intNumber = number.intValue
        var back = 0
        
        while (intNumber > 1000 && iUnit < 3) {
            back = ((intNumber % 1000) / 100)
            intNumber = intNumber / 1000
            iUnit += 1
        }
        
        if back == 0{
            return String(format: "%lli%@", intNumber, units[iUnit])
        }
        else {
            return String(format: "%lli.%i%@", intNumber, back, units[iUnit])
        }
    }
    
    static func numberFormat(_ number: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = "."
        numberFormatter.decimalSeparator = ","
        numberFormatter.generatesDecimalNumbers = false
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: number)!
    }
    
    static func numberFormat(_ number: NSNumber, decimal: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = "."
        numberFormatter.decimalSeparator = ","
        numberFormatter.generatesDecimalNumbers = true
        numberFormatter.maximumFractionDigits = decimal
        return numberFormatter.string(from: number)!
    }
    
    static func timeAgo(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = Date()
        let date = dateFormatter.date(from: dateString)
        var diff = now.timeIntervalSince(date!)
        var n = 0.0;
        
        //seconds
        n = fmod(diff, 60)
        diff = floor(diff/60)
        if diff == 0 {
            return String(format: "%0.f seconds ago", n)
        }
        
        //minutes
        n = fmod(diff, 60)
        diff = floor(diff / 60)
        if diff == 0 {
            return String(format: "%0.f minutes ago", n)
        }
        
        //hours
        n = fmod(diff, 24)
        diff = floor(diff / 24)
        if diff == 0 {
            return String(format: "%0.f hours ago", n)
        }
        else if diff == 1 {
            return "yesterday"
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return Globals.dateFormat(dateString)
    }
    
    static func dateTimeFormat(_ dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        return dateFormatter.string(from: date!)
    }
    
    static func dateFormat(_ dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date!)
    }
    
    static func shortDateFormat(_ dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date!)
    }
    
    static func timeFromNow(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = Date()
        let date = dateFormatter.date(from: dateString)
        var diff = date!.timeIntervalSince(now)
        var n = 0.0;
        
        //seconds
        n = fmod(diff, 60)
        diff = floor(diff/60)
        if diff == 0 {
            return String(format: "%0.f seconds from now", n)
        }
        
        //minutes
        n = fmod(diff, 60)
        diff = floor(diff / 60)
        if diff == 0 {
            return String(format: "%0.f minutes from now", n)
        }
        
        //hours
        n = fmod(diff, 24)
        diff = floor(diff / 24)
        if diff == 0 {
            return String(format: "%0.f hours from now", n)
        }
        else if diff == 1 {
            return "tomorrow"
        }
        
        //days
        n = fmod(diff, 30)
        diff = floor(diff / 30)
        if diff == 0 {
            return String(format: "%0.f days from now", n)
        }
        
        //months
        n = fmod(diff, 12)
        diff = floor(diff / 12)
        if diff == 0 {
            return String(format: "%0.f months from now", n)
        }
        else {
            return String(format: "%0.f years from now", diff)
        }
    }
    
    static func setUserDefault(_ key: String, forkey: String) {
        UserDefaults.standard.set(key, forKey: forkey)
    }
    
    static func getUserDefault(_ key: String) -> Any {
        var result: Any = UserDefaults.standard.object(forKey: key)
        
        return result
    }
    
}

extension UIView {
    @discardableResult
    func corners(_ radius: CGFloat) -> UIView {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
        return self
    }
    
    @discardableResult
    func shadow(radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float) -> UIView {
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        
        return self
    }
    // OUTPUT 1
    func dropShadow1(scale: Bool = true) {
        layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 7.0
        layer.shadowOpacity = 0.2
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow2(color: UIColor, opacity: Float = 0.3, offSet: CGSize, radius: CGFloat = 8, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func dropShadow3() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.withAlphaComponent(5).cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 13)
//        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
//                                                     y: bounds.maxY - layer.shadowRadius,
//                                                     width: bounds.width,
//                                                     height: layer.shadowRadius)).cgPath
    }
    
    func dropShadow4() {
            layer.masksToBounds = false
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.1
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOffset = CGSize(width: 0 , height: 5.0)
    }
    
    func dropShadow5() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.withAlphaComponent(5).cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 3)
    }
}
