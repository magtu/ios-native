import UIKit
import Foundation

class TableFooter: UIView {
    override func drawRect(rect: CGRect) {
        self.roundCorners([.BottomLeft, .BottomRight], radius: 10)
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}