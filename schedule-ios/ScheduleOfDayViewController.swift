import UIKit

class ScheduleOfDayViewController: UIViewController {
    var b = false
    var s = "AS"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = s
        
        return cell
    }

    func curlUp(view: UITableView) {
        UIView.animateWithDuration(1){
            
        }
        
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(NSTimeInterval(1))
        UIView.setAnimationTransition(UIViewAnimationTransition.CurlUp, forView: view, cache: false)
        UIView.commitAnimations()
    }
    
    @IBAction func rightSwipeHandle(sender: AnyObject) {

        }
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
