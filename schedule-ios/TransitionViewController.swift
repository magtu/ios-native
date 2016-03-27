import UIKit

class TransitionViewController: UIViewController {
    @IBOutlet weak var groupNameLabel: UILabel!
    var groupName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            groupNameLabel.text = groupName
    }
}
