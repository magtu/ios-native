import UIKit
class ScheduleViewController: UIViewController, UITabBarDelegate, UIPageViewControllerDataSource {
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    var pageViewController: UIPageViewController!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var day: Day!
    var cDay: Day! {
        get {return self.day}
        set {
            self.day = newValue
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
    var startVC: ScheduleTableViewController!
    // ============================================================================================
    // LIFECYCLE
    // ============================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
                
        pageViewController = storyboard?.instantiateViewControllerWithIdentifier("pagevc") as! UIPageViewController
        pageViewController.dataSource = self
        
      //  startVC = storyboard?.instantiateViewControllerWithIdentifier("ScheduleTableViewController") as! ScheduleTableViewController
        //pageViewController.setViewControllers([startVC], direction: .Forward, animated: true, completion: nil)
        
        navItem.title = GroupManager.instanse.currentGroup!.name
        
        ScheduleManager.instanse.onScheduleEvent.add(self, ScheduleViewController.onLoadSchedule)
        ScheduleManager.instanse.onUpdateEventTimer.add(self, ScheduleViewController.onUpdateEventTimer)
        ScheduleManager.instanse.onLoadingScheduleEvent.add(self, ScheduleViewController.blockUIForloading)
        ScheduleManager.instanse.onLoadingScheduleFailedEvent.add(self, ScheduleViewController.unblockUIWithLoadingFailed)
        
        let appearance = UITabBarItem.appearance()
        
        appearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName : UIFont.systemFontOfSize(18)], forState: .Normal)
        appearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
        
        tabBar.delegate = self
        
//        startVC.table.contentSize = CGSizeMake(table.frame.size.width, table.contentSize.height);
        
        startVC.table.estimatedRowHeight = 86
        startVC.table.rowHeight = UITableViewAutomaticDimension
        adapter = ScheduleAdapterViewController()
        adapter.bind(startVC.table, vc: self)
        
        loadSchedule()
    }
    
    func viewControllerAtIndex(index: Int) -> ScheduleTableViewController? {
        if  (index >= 7) || (index < 0) {
            return nil
        }
        startVC.index = index
        cDay = getDay(index)
        
        adapter.loadCDay()
        onUpdateEventTimer()
        
        return startVC
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ScheduleTableViewController
        var index = vc.index as Int
        if (index < 0 || index == NSNotFound) { return nil }
        
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ScheduleTableViewController
        var index = vc.index as Int
        if (index == NSNotFound || index + 1 >= 7) { return nil }
        
        index += 1
        return viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 7
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    /*func curl(transition: UIViewAnimationTransition){
     
     UIView.beginAnimations(nil, context: nil)
     UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
     UIView.setAnimationDuration(NSTimeInterval(0.5))
     UIView.setAnimationTransition(transition, forView: table.superview!, cache: false)
     
     UIView.commitAnimations()
     }*/
    
    @IBAction func backSwipeHandle(sender: UISwipeGestureRecognizer) {
        if cDay.id - 1 > 0 {
            cDay = getDay(cDay.id - 1)
        }
        else {
            cWeekType = cWeekType == .ODD ? .EVEN : .ODD
            cDay = getDay(6)
        }
        
    }
    @IBAction func frontSwipeHandle(sender: UISwipeGestureRecognizer) {
        
        if cDay.id + 1 < 7 {
            cDay = getDay(cDay.id + 1)
        }
        else {
            cWeekType = cWeekType == .ODD ? .EVEN : .ODD
            cDay = getDay(1)
        }
        
    }
    
    @IBAction func toCDayClick(sender: UIBarButtonItem) {
        let now = ScheduleManager.instanse.cDayWType
        if (now.day === cDay && now.weekType == cWeekType) {return}
        
        let t: UIViewAnimationTransition = cDay.id > now.day.id ? .CurlDown : .CurlUp
        (cDay, cWeekType) = now
        
    }
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 0 && cWeekType != .EVEN {
            cWeekType = .EVEN
            cDay = getDay(cDay.id)
            
        }
        else if item.tag == 1 && cWeekType != .ODD {
            cWeekType = .ODD
            cDay = getDay(cDay.id)
            
        }
    }
    
    func getDay(id: Int) -> Day {
        return ScheduleManager.instanse.getDay(id+1, weekType: cWeekType)
    }
    
    @IBAction func onMenuClick(sender: AnyObject) {
        navTo(.SearchViewController)
    }
    
    func blockUIForloading(){
        view.hidden = true
        loadingLabel.hidden = false
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        tabBar.hidden = true
    }
    
    func unblockUI() {
        tabBar.hidden = false
        loadingLabel.hidden = true
        view.hidden = false
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    func unblockUIWithLoadingFailed() {
        unblockUI()
        showAlert("Не удалось обновить расписание" ,btnhndrs: [:], needCancelBtn: true, cancelBtn: "Ok")
    }
    // ============================================================================================
    // MANAGER REQUEST
    // ============================================================================================
    func loadSchedule() {ScheduleManager.instanse.getSchedule()}
    // ============================================================================================
    // MANAGER RESPONSE
    // ============================================================================================
    func onLoadSchedule() {
        unblockUI()
        (cDay, cWeekType) = ScheduleManager.instanse.cDayWType
        adapter.loadCDay()
        onUpdateEventTimer()
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
