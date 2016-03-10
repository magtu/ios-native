import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let r = Request(command: Api.SCHEDULE, urlPaths: ["1"])

        Api.instance.send(request: r, listener: ScheduleManager())
    }
    
}

