import UIKit
class ScheduleViewController: UIViewController, UITabBarDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // ============================================================================================
    // @IBOutlets
    // ============================================================================================
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var tableContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var evenRoundView: RoundView!
    @IBOutlet weak var oddRoundView: RoundView!
    var cDayID: Int?
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    var pageViewController: UIPageViewController!
    // ============================================================================================
    // LIFECYCLE
    // ============================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScheduleManager.instanse.onLoadingScheduleEvent.add(self, ScheduleViewController.blockUIForloading)
        ScheduleManager.instanse.onLoadingScheduleFailedEvent.add(self, ScheduleViewController.unblockUIWithLoadingFailed)
        ScheduleManager.instanse.onScheduleEvent.add(self, ScheduleViewController.onLoadSchedule)
        
        prepareToShow()
        ScheduleManager.instanse.cDayWType.weekType == .EVEN ? setEvenSegment() : setOddSegment()
    }
    func setEvenSegment() {
        evenRoundView.hidden = false
        evenRoundView.backgroundColor = Colors.WHITE
        oddRoundView.hidden  = true
        segmentControl.selectedSegmentIndex = 0
    }
    func setOddSegment() {
        evenRoundView.hidden = true
        oddRoundView.hidden  = false
        oddRoundView.backgroundColor = Colors.WHITE
        segmentControl.selectedSegmentIndex = 1
    }
    func onLoadSchedule() {
        //TODO
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
        vc.day = getDay(index)
        _ = vc.view
        
        return vc
    }
    //back scroll
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ScheduleTableViewController
        var index = vc.index
        
        if (index < 0 || index == NSNotFound) { return nil }
        
        index -= 1
        return viewControllerAtIndex(index)
    }
    //forward scroll
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ScheduleTableViewController
        var index = vc.index
        if (index == NSNotFound || index + 1 >= 7) { return nil }
        
        index += 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let vc = pageViewController.viewControllers?.last as! ScheduleTableViewController
        cDayID = vc.day.id
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 7
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if cDayID != nil {return cDayID! - 1 } else {return ScheduleManager.instanse.cDayWType.day.id - 1 }
    }

    @IBAction func onMenuClick(sender: AnyObject) {
        navTo(.SearchViewController)
    }
    @IBAction func segmentControllClick(sender: UISegmentedControl) {
        let type: WeekType = sender.selectedSegmentIndex == 0 ? .EVEN : .ODD
        setDayofWeek(ScheduleManager.instanse.cDayWType.day, weekType: type)
        if type == .EVEN {
            evenRoundView.backgroundColor = Colors.WHITE
            oddRoundView.backgroundColor =  Colors.VIOLET
        } else {
            oddRoundView.backgroundColor = Colors.WHITE
            evenRoundView.backgroundColor = Colors.VIOLET
        }
    }
    
    func setDayofWeek(day: Day, weekType: WeekType) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ScheduleTableViewController") as! ScheduleTableViewController
        
        vc.day = ScheduleManager.instanse.getDay(cDayID!, weekType: weekType)
        vc.index = vc.day.id - 1
        
        pageViewController.setViewControllers([vc], direction: weekType == .EVEN ? .Reverse : .Forward, animated: true, completion: nil)
        _ = vc.view
    }
    
    func getDay(id: Int) -> Day {
        return ScheduleManager.instanse.getDay(id+1, weekType: ScheduleManager.instanse.cDayWType.weekType)
    }
    // ============================================================================================
    // SERVICES
    // ============================================================================================
    func blockUIForloading() {
        view.hidden = true
        loadingLabel.hidden = false
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
    }
    
    func unblockUI() {
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
        pageViewController.delegate = self
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ScheduleTableViewController") as! ScheduleTableViewController
        vc.day = ScheduleManager.instanse.getDay(ScheduleManager.instanse.cDayWType.day.id, weekType: ScheduleManager.instanse.cDayWType.weekType)
        vc.index = vc.day.id - 1
        cDayID = vc.day.id
        pageViewController.setViewControllers([vc], direction: .Forward, animated: true, completion: nil)
        addChildViewController(pageViewController)
        pageViewController.view.frame = CGRectMake(0, 0, tableContainer.frame.size.width, tableContainer.frame.size.height)
        tableContainer.addSubview(pageViewController.view)
        
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName : UIFont.systemFontOfSize(18)], forState: .Normal)
        appearance.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
        
        _ = vc.view
    }
}
