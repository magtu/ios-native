import UIKit
class ScheduleViewController: UIViewController, UITabBarDelegate {
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var footerView: TableFooter!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var pageControl: UIPageControl!
    var day: Day!
    var cDay: Day! {
        get {return self.day}
        set {
            self.day = newValue
            pageControl.currentPage = day.id - 1
        }
    }
    var adapter: ScheduleAdapterViewController!
    var weekType: WeekType!
    var cWeekType: WeekType! {
        get {return self.weekType}
        set {
                self.weekType = newValue
                tabBar.selectedItem = tabBar.items![newValue == .EVEN ? 0 : 1]
            }
    }
    
    // ============================================================================================
    // LIFECYCLE
    // ============================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItem.title = GroupManager.instanse.currentGroup!.name
        
        ScheduleManager.instanse.onScheduleEvent.add(self, ScheduleViewController.onLoadSchedule)
        ScheduleManager.instanse.onTimeUpdateEvent.add(self, ScheduleViewController.onTimeUpdate)
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "System Bold", size: 20) as! AnyObject]
        appearance.setTitleTextAttributes(attributes, forState: .Normal)

        tabBar.delegate = self

        table.layer.cornerRadius = 10
        table.estimatedRowHeight = 86
        table.rowHeight = UITableViewAutomaticDimension
        adapter = ScheduleAdapterViewController()
        adapter.bind(table, vc: self)
        
        loadSchedule()
    }
    
    func curl(transition: UIViewAnimationTransition){
        adapter.loadCDay()
        onTimeUpdate()
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(NSTimeInterval(1))
        UIView.setAnimationTransition(transition, forView: table.superview!, cache: false)
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
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 0 && cWeekType != .EVEN {
            cWeekType = .EVEN
            cDay = getDay(cDay.id)
            curl(.FlipFromLeft)
        }
        else if item.tag == 1 && cWeekType != .ODD {
            cWeekType = .ODD
            cDay = getDay(cDay.id)
            curl(.FlipFromRight)
        }        
    }
   
    func getDay(ID: Int) -> Day {
       return ScheduleManager.instanse.getDay(ID, weekType: cWeekType)
    }
    
    @IBAction func onMenuClick(sender: AnyObject) {
        navTo(.SearchViewController)
    }
    // ============================================================================================
    // MANAGER REQUEST
    // ============================================================================================
    func loadSchedule() {ScheduleManager.instanse.getSchedule()}    
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
