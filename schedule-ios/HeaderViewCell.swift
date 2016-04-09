import UIKit

class HeaderViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cDayIndicator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func drawRect(rect: CGRect) {
        roundCorners([.TopLeft, .TopRight], radius: 10)
        cDayIndicator.roundCorners([.AllCorners], radius: 10)
    }
    
    func create(dayName: String, showCDayIndicator: Bool) {
        name.text = dayName
        
        cDayIndicator.hidden = !showCDayIndicator
    }
}
	