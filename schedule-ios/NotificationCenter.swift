import UIKit
extension UIViewController {
    func showAlert(desc: String, btnhndrs: [String: ()->()], needCancelBtn: Bool = true, cancelBtn: String = "Отмена"){
        let alert = UIAlertController(title: "", message: desc, preferredStyle: .Alert)
        btnhndrs.forEach{name, hndr in
            alert.addAction(UIAlertAction(title: name, style: .Default, handler: { _ in hndr()}))
        }
        if needCancelBtn {alert.addAction(UIAlertAction(title: cancelBtn, style: .Cancel, handler: nil))}
        presentViewController(alert, animated: true, completion: nil)
    }
}