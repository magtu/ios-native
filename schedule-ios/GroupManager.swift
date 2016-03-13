import Foundation

class GroupManager: GroupsListner{
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    static let instanse = GroupManager()
    var groups: [Group] = []
    // ============================================================================================
    // EVENTS
    // ============================================================================================
    var onGroupsEvent = ObserverSet<[Group]>()
    var onGroupsEventFailed: ObserverSet<()> = ObserverSet()
    // ============================================================================================
    // API REQUEST
    // ============================================================================================
    func getGroups(name: String? = nil){Api.instance.groups(name, listener: self)}
    // ============================================================================================
    // API RESPONSE
    // ============================================================================================
    func onGroups(groups:[Group]){
        self.groups = groups
        onGroupsEvent.notify(groups)
    }
    
    func onGroupsFailed(){
        onGroupsEventFailed.notify()
    }
}