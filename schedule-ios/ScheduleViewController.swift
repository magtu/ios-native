import UIKit
class ScheduleViewController: UIViewController, UITabBarDelegate, UIPageViewControllerDataSource {
    // ============================================================================================
    // @IBOutlets
    // ============================================================================================
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var tableContainer: UIView!
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    var pageViewController: UIPageViewController!
    var cDay: Day!
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
        
        ScheduleManager.instanse.onScheduleEvent.add(self, ScheduleViewController.onLoadSchedule)
        ScheduleManager.instanse.onUpdateEventTimer.add(self, ScheduleViewController.onUpdateEventTimer)
        ScheduleManager.instanse.onLoadingScheduleEvent.add(self, ScheduleViewController.blockUIForloading)
        ScheduleManager.instanse.onLoadingScheduleFailedEvent.add(self, ScheduleViewController.unblockUIWithLoadingFailed)
        
        prepareToShow()
        loadSchedule()
    }
    func updateVC() {
        adapter.loadCDay()
        onUpdateEventTimer()
    }
    // ============================================================================================
    // TABLE SETTINGS
    // ============================================================================================
    //get next vc
    func viewControllerAtIndex(index: Int) -> ScheduleTableViewController? {
        if  (index >= 7) || (index < 0) {
            return nil
        }
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ScheduleTableViewController") as! ScheduleTableViewController
        vc.index = index
        cDay = getDay(index)
        _ = vc.view
        adapter.bind(vc.table, vc: self)
        updateVC()
        
        return vc
    }
    //back scroll
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ScheduleTableViewController
        var index = vc.index as Int
        if (index < 0 || index == NSNotFound) { return nil }
        
        index -= 1
        return viewControllerAtIndex(index)
    }
    //forward scroll
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
    
    @IBAction func toCDayClick(sender: UIBarButtonItem) {
        let now = ScheduleManager.instanse.cDayWType
        if (now.day === cDay && now.weekType == cWeekType) {return}
        (cDay, cWeekType) = now
        updateVC()
    }
    
    @IBAction func onMenuClick(sender: AnyObject) {
        navTo(.SearchViewController)
    }
    
    func getDay(id: Int) -> Day {
        return ScheduleManager.instanse.getDay(id+1, weekType: cWeekType)
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
        updateVC()
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
    
    // ============================================================================================
    // SERVICES
    // ============================================================================================
    func blockUIForloading() {
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
    
    func prepareToShow() {
        navItem.title = GroupManager.instanse.currentGroup!.name
        
        pageViewController = storyboard?.instantiateViewControllerWithIdentifier("pagevc") as! UIPageViewController
        pageViewController.dataSource = self
        let startVC = storyboard?.instantiateViewControllerWithIdentifier("ScheduleTableViewController") as! ScheduleTableViewController
        pageViewController.setViewControllers([startVC], direction: .Forward, animated: true, completion: nil)
        addChildViewController(pageViewController)
        pageViewController.view.frame = CGRectMake(0, 0, tableContainer.frame.size.width, tableContainer.frame.size.height)
        tableContainer.addSubview(pageViewController.view)
        
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName : UIFont.systemFontOfSize(18)], forState: .Normal)
        appearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
        
        tabBar.delegate = self
        
        adapter = ScheduleAdapterViewController()
        adapter.bind(startVC.table, vc: self)
    }
}
