import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, GroupsListner {
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
    func onGroups(loadedGroups: [Group]) {groups = loadedGroups}
    func onGroupsFailed() {}
    //============================================================================================
    // METHODS
    //============================================================================================
    private func loadGroups() {GroupManager.instanse.getGroups()}
}
    