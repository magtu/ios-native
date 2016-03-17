import UIKit

class ScheduleViewController: UIViewController {
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    @IBOutlet weak var table: UITableView! 
    @IBOutlet weak var weekLabel: UILabel!
    var cDay: Day!
    var adapter: ScheduleAdapterViewController!
    var weekType: WeekType!
    var cWeekType: WeekType! {
        get {return self.weekType}
        set {self.weekType = newValue; weekLabel.text = newValue.rawValue}
        }
    // ============================================================================================
    // LIFECYCLE
    // ============================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScheduleManager.instanse.onScheduleEvent.add(self, ScheduleViewController.onLoadSchedule)
       
        table.estimatedRowHeight = 88
        table.rowHeight = UITableViewAutomaticDimension
        adapter = ScheduleAdapterViewController()
        adapter.bind(table, vc: self)
        
        loadSchedule()
    }
    
    func curl(transition: UIViewAnimationTransition){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(NSTimeInterval(1))
        UIView.setAnimationTransition(transition, forView: table, cache: false)
        adapter.loadCDay()
        UIView.commitAnimations()
    }
    
    @IBAction func backSwipeHandle(sender: AnyObject) {
        if cDay.id - 1 > 0 {
            cDay = getDay(cDay.id - 1)
        }
        else {
            cWeekType = cWeekType == .ODD ? .EVEN : .ODD
            cDay = getDay(6)
        }
        curl(.CurlDown)
    }
    @IBAction func frontSwipeHandle(sender: AnyObject) {
        if cDay.id + 1 < 8 {
            cDay = getDay(cDay.id + 1)
        }
        else {
            cWeekType = cWeekType == .ODD ? .EVEN : .ODD
            cDay = getDay(1)
        }
        curl(.CurlUp)
    }
    
    func getDay(ID: Int) -> Day {
       return ScheduleManager.instanse.getDay(ID, weekType: cWeekType)
    }
    // ============================================================================================
    // MANAGER REQUEST
    // ============================================================================================
    func loadSchedule() {ScheduleManager.instanse.getSchedule()}
    // ============================================================================================
    // MANAGER RESPONSE
    // ============================================================================================
    func onLoadSchedule() {
        //calculate current weekDay
        cDay = ScheduleManager.instanse.weeks[.ODD]!.days[3]
        cWeekType = .ODD
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components([.WeekOfYear, .Day, .Month, .Year], fromDate: NSDate(timeIntervalSinceNow: 0))
        print("weekOfYear \(dateComponent.weekOfYear)")
        
        adapter.loadCDay()
//        adapter.loadCDay(schedule[WeekType.ODD]!.days[0])
    }
}
