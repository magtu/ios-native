import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    //============================================================================================
    // FIELDS
    //============================================================================================
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadGroupsButton: UIButton!
    @IBOutlet weak var groupEmptyLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var groups: [SearchingGroup] = []
    var searchingGroups: [SearchingGroup] = []
    @IBOutlet weak var navBar: UINavigationBar!
    //============================================================================================
    // INIT
    //============================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()

        if AppDelegate.nc.viewControllers.count == 1 {
            backButton.hidden = true
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar.delegate = self
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = UIColor.blackColor()
       /* let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.valueForKey("placeholderLabel") as? UILabel
            textFieldInsideSearchBarLabel?.textColor = UIColor.whiteColor()
        */
        GroupManager.instanse.onGroupsEvent.add(self, SearchViewController.onGroups)
        GroupManager.instanse.onGroupsEventFailed.add(self, SearchViewController.onGroupsFailed)
        GroupManager.instanse.onGetSchOfSelGroupEvent.add(self, SearchViewController.readyGoToSchedule)
        GroupManager.instanse.onInternetConnectionEventFailed.add(self, SearchViewController.onInternetConnectionFailed)
        GroupManager.instanse.onGetSchOfSelGroupEventFailed.add(self, SearchViewController.getSchOfSelGroupEventFailed)
        loadGroups()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingGroups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = searchingGroups[indexPath.row].name
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        blockTableforLoad()
        GroupManager.instanse.getSchOfSelGroup(searchingGroups[indexPath.row].id)        
    }
    //============================================================================================
    // VIEW HANDLER
    //============================================================================================
    func searchBar(searchBar: UISearchBar, var textDidChange searchText: String) {
        searchText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        searchingGroups = groups.filter{ g in
            return g.name.lowercaseString.rangeOfString(searchText.lowercaseString, options: NSStringCompareOptions.AnchoredSearch) != nil
        }
        tableView.reloadData()
    }
    @IBAction func loadgroupsClick(sender: UIButton) {
        loadGroups()
    }
    @IBAction func backClick(sender: AnyObject) {
        navBack(true)
    }
    //============================================================================================
    // GROUP MANAGER HANDLER
    //============================================================================================
    func onGroups(loadedGroups: [SearchingGroup]) {
        unblockTable()
        groups = loadedGroups
    }
    
    func onGroupsFailed() {
        blockTableFailed("Нет списка групп")
        showAlert("Проблема с сервером", btnhndrs: ["Повторить": {self.loadGroups()}])
    }
    
    func onInternetConnectionFailed() {
        blockTableFailed("Нет соединения с интернетом")
    }
    
    func getSchOfSelGroupEventFailed() {
        unblockTable()
        showAlert("Не удалось загрузить расписание", btnhndrs: ["Повторить": {
            self.blockTableforLoad()
            GroupManager.instanse.getSchOfSelGroup(GroupManager.instanse.selectedSearchingGroup.id)}])
    }
    
    func readyGoToSchedule() {
        setTo(.ScheduleViewController)
    }
    //============================================================================================
    // METHODS
    //============================================================================================
    private func loadGroups() {
        blockTableforLoad()
        GroupManager.instanse.getGroups()
    }
    
    private func unblockTable(){
        searchBar.hidden = false
        actIndicator.hidden = true
        actIndicator.stopAnimating()
        tableView.hidden = false
        groupEmptyLabel.hidden = true
        loadGroupsButton.hidden = true
    }
    private func blockTableforLoad() {
        searchBar.hidden = true
        actIndicator.hidden = false
        actIndicator.startAnimating()
        tableView.hidden = true
        groupEmptyLabel.hidden = true
        loadGroupsButton.hidden = true
    }
    
    private func blockTableFailed(reason: String) {
        groupEmptyLabel.text = reason
        searchBar.hidden = true
        actIndicator.hidden = true
        actIndicator.stopAnimating()
        tableView.hidden = true
        groupEmptyLabel.hidden = false
        loadGroupsButton.hidden = false
    }
}
    