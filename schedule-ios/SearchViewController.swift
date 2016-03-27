import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, GroupsListner {
    //============================================================================================
    // FIELDS
    //============================================================================================
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var groups: [Group] = []
    var searchingGroups: [Group] = []
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
      //  let vc = storyboard!.instantiateViewControllerWithIdentifier("ScheduleViewController")
      //  navigationController?.setViewControllers([vc], animated: true)
        
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ScheduleViewController") as! ScheduleViewController
        presentViewController(nextViewController, animated:true, completion:nil)
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
    // API HANDLER
    //============================================================================================
    func onGroups(loadedGroups: [Group]) {
        groups = loadedGroups
        GroupManager.instanse.selectedGroup = groups.filter{$0.name == "ЭАВбп-13-1"}.first!
        let vc = storyboard!.instantiateViewControllerWithIdentifier("ScheduleViewController")
        navigationController?.setViewControllers([vc], animated: true)
}
    func onGroupsFailed() {}
    //============================================================================================
    // METHODS
    //============================================================================================
    private func loadGroups() {GroupManager.instanse.getGroups()}
}
    