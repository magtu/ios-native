import UIKit

class HeaderViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func drawRect(rect: CGRect) {
        roundCorners([.TopLeft, .TopRight], radius: 10)
    }
    
    func create(dayName: String) {
        name.text = dayName
    }
}
