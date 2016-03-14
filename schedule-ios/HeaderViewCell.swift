import UIKit

class HeaderViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func create(dayName: String) {
        name.text = dayName
    }
}
