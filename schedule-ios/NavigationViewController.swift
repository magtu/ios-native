import UIKit

class NavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.nc = self
    }
    override func viewDidAppear(animated: Bool) {
        (GroupManager.instanse.currentGroup != nil) ?
            setTo(.ScheduleViewController)
          :
            setTo(.SearchViewController)
    }
}
extension UIViewController {
    enum Views : String {
        case ScheduleViewController   = "ScheduleViewController"
        case SearchViewController     = "SearchViewController"
    }
    
    func navBack(animate: Bool) {
        AppDelegate.nc.popViewControllerAnimated(animate)
    }
    func setTo(v: Views) {
        AppDelegate.nc.setViewControllers([UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier(v.rawValue)], animated: true)
    }
    
    func navTo(v: Views) {
        AppDelegate.nc.pushViewController(UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier(v.rawValue), animated: true)
    }
}