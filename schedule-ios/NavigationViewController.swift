import UIKit

class NavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.nc = self
    }
    override func viewDidAppear(animated: Bool) {
        (GroupManager.instanse.currentGroup != nil) ? navForward(.ScheduleViewController) : navTo(.SearchViewController)
    }
}
extension UIViewController {
    enum Views : String {
        case ScheduleViewController   = "ScheduleViewController"
        case SearchViewController     = "SearchViewController"
        case TransitionViewController = "TransitionViewController"
    }
    func navTo(v: Views) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(v.rawValue)
        switch v {
        case .ScheduleViewController:
            presentViewController(nextViewController as! ScheduleViewController, animated:true, completion:nil)
            
        case .SearchViewController:
            presentViewController(
                {let nv = nextViewController as! SearchViewController
                    nv.navBar.frame.size.height = 0; return nv}(),
                animated:true, completion:nil)
            
        case .TransitionViewController:
            AppDelegate.nc.setViewControllers([nextViewController as! TransitionViewController], animated: true)
            //presentViewController(nextViewController as! TransitionViewController, animated:true, completion:nil)
        }
    }
    
    func navBack(animate: Bool) {
        AppDelegate.nc.popViewControllerAnimated(animate)
    }
    
    func navForward(v: Views) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(v.rawValue)
        switch v {
        case .ScheduleViewController:
             AppDelegate.nc.pushViewController(nextViewController as! ScheduleViewController, animated: true)
            
        case .SearchViewController:
            AppDelegate.nc.pushViewController(nextViewController as! SearchViewController, animated: true)
            
        case .TransitionViewController:
            AppDelegate.nc.pushViewController(nextViewController as! TransitionViewController, animated: true)
        }
    }
}