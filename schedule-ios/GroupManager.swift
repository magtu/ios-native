import Foundation

class GroupManager: GroupsListner{
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    static let instanse = GroupManager()
    var groups: [SearchingGroup] = []
    var selectedGroup: (id: Int, name:String)!
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
    func getSchOfSelGroup(id: Int, name: String) {
        selectedGroup = (id, name)
        Api.instance.scheduleOfGroup(selectedGroup.id, listener: GroupManager.instanse)
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