import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    //============================================================================================
    // FIELDS
    //============================================================================================
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var groups: [SearchingGroup] = []
    var searchingGroups: [SearchingGroup] = []
    //============================================================================================
    // INIT
    //============================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
               
        tableView.rowHeight = UITableViewAutomaticDimension
        searchBar.delegate = self
        
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.valueForKey("placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.whiteColor()

        GroupManager.instanse.onGroupsEvent.add(self, SearchViewController.onGroups)
        GroupManager.instanse.onGroupsEventFailed.add(self, SearchViewController.onGroupsFailed)
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
        GroupManager.instanse.selectedGroup = searchingGroups[indexPath.row]
        Api.instance.scheduleOfGroup(GroupManager.instanse.selectedGroup.id, listener: GroupManager.instanse)
        
        
        
      //  let vc = storyboard!.instantiateViewControllerWithIdentifier("ScheduleViewController")
      //  navigationController?.setViewControllers([vc], animated: true)
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
    //============================================================================================
    // GROUP MANAGER HANDLER
    //============================================================================================
    func onGroups(loadedGroups: [SearchingGroup]) {
        groups = loadedGroups
   /*     GroupManager.instanse.selectedGroup = groups.filter{$0.name == "ЭАВбп-13-1"}.first!
        let vc = storyboard!.instantiateViewControllerWithIdentifier("ScheduleViewController")
        navigationController?.setViewControllers([vc], animated: true)*/
}
    
    func readyGoToSchedule() {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ScheduleViewController") as! ScheduleViewController
        presentViewController(nextViewController, animated:true, completion:nil)
    }
    func onGroupsFailed() {}
    //============================================================================================
    // METHODS
    //============================================================================================
    private func loadGroups() {GroupManager.instanse.getGroups()}

}
    