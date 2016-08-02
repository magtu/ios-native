import UIKit

class segmentControl: UISegmentedControl {
    override func drawRect(rect: CGRect) {
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor = Colors.VIOLET.CGColor
    }
}