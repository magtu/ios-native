import UIKit

class RoundView: UIView {
    override func drawRect(rect: CGRect) {
        roundCorners([.AllCorners], radius: 10)
    }
}
