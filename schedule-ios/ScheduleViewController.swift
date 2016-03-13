import UIKit

class ScheduleViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    let adapter = ScheduleAdapterViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.rowHeight = UITableViewAutomaticDimension
        table.dataSource = adapter
        table.delegate   = adapter
    }
    func curlUp() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(NSTimeInterval(1))
        UIView.setAnimationTransition(UIViewAnimationTransition.CurlUp, forView: view, cache: false)
        
        table.reloadData()

        UIView.commitAnimations()
    }
    @IBAction func rightSwipeHandle(sender: AnyObject) {
        curlUp()
    }
}
