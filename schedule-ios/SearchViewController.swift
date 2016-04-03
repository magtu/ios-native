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
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.valueForKey("placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.whiteColor()
        
        GroupManager.instanse.onGroupsEvent.add(self, SearchViewController.onGroups)
        GroupManager.instanse.onGetSchOfSelGroupEvent.add(self, SearchViewController.readyGoToSchedule)
        
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
        GroupManager.instanse.selectedSearchingGroup = searchingGroups[indexPath.row]
        Api.instance.scheduleOfGroup(GroupManager.instanse.selectedSearchingGroup.id, listener: GroupManager.instanse)
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
    
    func readyGoToSchedule() {
        setTo(.ScheduleViewController)
    }
    //============================================================================================
    // METHODS
    //============================================================================================
    private func loadGroups() {
        InternetManager.isConnectedToNetwork() ? {blockTableforLoad();GroupManager.instanse.getGroups()}()
            : {blockTableWithoutInternet();
                showAlert("Нет соединения с интернетом", btnhndrs: ["Повторить": {self.loadGroups()}])}()
    }
    private func unblockTable(){
        actIndicator.hidden = true
        actIndicator.stopAnimating()
        tableView.hidden = false
        groupEmptyLabel.hidden = true
        loadGroupsButton.hidden = true

    }
    private func blockTableforLoad() {
        actIndicator.hidden = false
        actIndicator.startAnimating()
        tableView.hidden = true
        groupEmptyLabel.hidden = true
        loadGroupsButton.hidden = true
    }
    
    private func blockTableWithoutInternet() {
        actIndicator.hidden = true
        actIndicator.stopAnimating()
        tableView.hidden = true
        groupEmptyLabel.hidden = false
        loadGroupsButton.hidden = false
    }
}
    