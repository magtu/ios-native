import Foundation

class GroupManager: GroupsListner{
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    static let instanse = GroupManager()
    var groups: [SearchingGroup] = []
    var selectedGroup: SearchingGroup!
    lazy var currentGroup: Group? = {return DBManager.fetchCurrentGroup()}()
    // ============================================================================================
    // EVENTS
    // ============================================================================================
    var onGroupsEvent = ObserverSet<[SearchingGroup]>()
    var onGroupsEventFailed: ObserverSet<()> = ObserverSet()
    var onGetSchOfSelGroupEvent: ObserverSet<()> = ObserverSet()
    // ============================================================================================
    // API REQUEST
    // ============================================================================================
    func getGroups(name: String? = nil){Api.instance.groups(name, listener: self)}
    // ============================================================================================
    // API RESPONSE
    // ============================================================================================
    func onGetSchOfSelGroup(group: Group) {
        currentGroup = group
        onGetSchOfSelGroupEvent.notify()
    }
    
    func onGroups(groups:[SearchingGroup]){
        self.groups = groups
        onGroupsEvent.notify(groups)
    }
    
    func onGroupsFailed(){
        onGroupsEventFailed.notify()
    }
}