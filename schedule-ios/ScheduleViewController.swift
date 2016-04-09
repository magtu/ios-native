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
        ScheduleManager.instanse.onUpdateEventTimer.add(self, ScheduleViewController.onUpdateEventTimer)
       
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: ".SFUIDisplay-Light", size: 18) as! AnyObject]
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
        onUpdateEventTimer()
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(NSTimeInterval(1))
        UIView.setAnimationTransition(transition, forView: table.superview!, cache: false)
        
        UIView.commitAnimations()
    }
    
    private func isTapSwipeOnNavBar(sender: UISwipeGestureRecognizer) -> Bool {
        return (navBar.bounds.size.height >= sender.locationInView(view).y) ? true : false
    }
    @IBAction func backSwipeHandle(sender: UISwipeGestureRecognizer) {
        if isTapSwipeOnNavBar(sender) {return}
        if cDay.id - 1 > 0 {
            cDay = getDay(cDay.id - 1)
        }
        else {
            cWeekType = cWeekType == .ODD ? .EVEN : .ODD
            cDay = getDay(6)
        }
        curl(.CurlDown)
    }
    @IBAction func frontSwipeHandle(sender: UISwipeGestureRecognizer) {
        if isTapSwipeOnNavBar(sender) {return}
        if cDay.id + 1 < 8 {
            cDay = getDay(cDay.id + 1)
        }
        else {
            cWeekType = cWeekType == .ODD ? .EVEN : .ODD
            cDay = getDay(1)
        } 
        curl(.CurlUp)
    }
    
    @IBAction func toCDayClick(sender: UIBarButtonItem) {
        let now = ScheduleManager.instanse.cDayWType
        if (now.day === cDay && now.weekType == cWeekType) {return}
        
        let t: UIViewAnimationTransition = cDay.id > now.day.id ? .CurlDown : .CurlUp
        (cDay, cWeekType) = now
        curl(t)
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
    func onUpdateEventTimer() {
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
