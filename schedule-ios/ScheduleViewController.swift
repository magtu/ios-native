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
    var isRestingTime = false
    // ============================================================================================
    // LIFECYCLE
    // ============================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScheduleManager.instanse.onScheduleEvent.add(self, ScheduleViewController.onLoadSchedule)
        ScheduleManager.instanse.onTimeUpdateEvent.add(self, ScheduleViewController.onTimeUpdate)
       
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
        onTimeUpdate()
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
    func loadSchedule() {ScheduleManager.instanse.onSchedule([.ODD: Week(id: 1, type: .ODD, days: [])])}//ScheduleManager.instanse.getSchedule()}
    // ============================================================================================
    // MANAGER RESPONSE
    // ============================================================================================
    func onLoadSchedule() {
        (cDay, cWeekType) = ScheduleManager.instanse.cDayWType
        adapter.loadCDay()
    }
    func onTimeUpdate() {
        if ScheduleManager.instanse.cDayWType.day === cDay {
            let t = TimeProvider.cDayTimeStamp
            let cEvent = cDay.events.filter{t >= $0.eventFields.startAt && t <= $0.eventFields.endAt}.first
            if let e = cEvent {
                adapter.updateCEvent(e.eventFields.indx, part: Float(t - e.eventFields.startAt) / 5400)
            }
            else  {
                adapter.rmCEvent()
            }
        }
    }
    
}
