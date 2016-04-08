import Foundation

class GroupManager: GroupsListner{
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    static let instanse = GroupManager()
    var groups: [SearchingGroup] = []
    var selectedSearchingGroup: SearchingGroup!
    lazy var currentGroup: Group? = {return DBManager.fetchCurrentGroup()}()
    // ============================================================================================
    // EVENTS
    // ============================================================================================
    var onGroupsEvent = ObserverSet<[SearchingGroup]>()
    var onGroupsEventFailed: ObserverSet<()> = ObserverSet()
    var onGetSchOfSelGroupEvent: ObserverSet<()> = ObserverSet()
    var onGetSchOfSelGroupEventFailed: ObserverSet<()> = ObserverSet()
    var onInternetConnectionEventFailed: ObserverSet<()> = ObserverSet()
    // ============================================================================================
    // API REQUEST
    // ============================================================================================
    func getGroups(name: String? = nil){
        Api.instance.groups(name, listener: self)
    }
    func getSchOfSelGroup(id: Int) {
        GroupManager.instanse.selectedSearchingGroup = groups.filter{$0.id == id}.first!
        Api.instance.scheduleOfGroup(GroupManager.instanse.selectedSearchingGroup.id, listener: GroupManager.instanse)
    }
    // ============================================================================================
    // API RESPONSE
    // ============================================================================================
    func onGetSchOfSelGroup(group: Group) {
        currentGroup = group
        onGetSchOfSelGroupEvent.notify()
    }
    
    func onGetSchOfSelGroupFailed(){
        onGetSchOfSelGroupEventFailed.notify()
    }
    
    func onGroups(groups:[SearchingGroup]){
        self.groups = groups
        onGroupsEvent.notify(groups)
    }
    
    func onGroupsFailed(){
        onGroupsEventFailed.notify()
    }
    
    func onInternetConnectionFailed() {
        onInternetConnectionEventFailed.notify()
    }
}