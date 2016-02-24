import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Api.instance.send(request: Request(command: Api.GROUPS), listener: ResponseListener())
    }
    
}

