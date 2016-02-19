import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"]).responseJSON { (responseData) -> Void in
            let swiftyJsonVar = JSON(responseData.result.value!)
            
            if let resData = swiftyJsonVar["contacts"].arrayObject {
                var arrRes = resData as! [[String:AnyObject]]
            }
        }
    }
    
}

