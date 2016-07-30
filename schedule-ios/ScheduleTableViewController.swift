import UIKit

class ScheduleTableViewController: UIViewController {
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    @IBOutlet weak var table: UITableView!
    var index: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        table.estimatedRowHeight = 86
        table.rowHeight = UITableViewAutomaticDimension
        
    }
}

