import UIKit

class TransitionViewController: UIViewController {
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            groupNameLabel.text = GroupManager.instanse.currentGroup?.name
    }
    @IBAction func onNavBackClick(sender: UIBarButtonItem) {
        navBack(true)
    }
}
