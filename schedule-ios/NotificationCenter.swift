import UIKit
extension UIViewController {
    func showAlert(desc: String, btnhndrs: [String: ()->()], needCancelBtn: Bool = true){
        let alert = UIAlertController(title: "", message: desc, preferredStyle: .Alert)
        btnhndrs.forEach{name, hndr in
            alert.addAction(UIAlertAction(title: name, style: .Default, handler: { _ in hndr()}))
        }
        if needCancelBtn {alert.addAction(UIAlertAction(title: "Отмена", style: .Cancel, handler: nil))}
        presentViewController(alert, animated: true, completion: nil)
    }
}