import Foundation
import CoreData

class ScheduleManager: ScheduleListener {
    static let instanse = ScheduleManager()
    let updateEventTimer = Timer()
    let updateScheduleEventTimer = Timer()
    
    init() {
        updateEventTimer.onTimerEvent.add(self, ScheduleManager.updateEventTimerTick)
        GroupManager.instanse.onGetSchOfSelGroupEvent.add(self, ScheduleManager.loadingScheduleComplite)
        GroupManager.instanse.onGetSchOfSelGroupEventFailed.add(self, ScheduleManager.loadingScheduleFailed)
    }
    // ============================================================================================
    // EVENTS
    // ============================================================================================
    
    var onUpdateScheduleEvent: ObserverSet<()> = ObserverSet()
    var onUpdateScheduleFailedEvent: ObserverSet<()> = ObserverSet()
    
    var onLoadingScheduleEvent: ObserverSet<()> = ObserverSet()
    var onScheduleEvent: ObserverSet<()> = ObserverSet()
    var onLoadingScheduleFailedEvent: ObserverSet<()> = ObserverSet()
    
    var onUpdateEventTimer: ObserverSet<()> = ObserverSet()
    var onInternetConnectionEventFailed: ObserverSet<()> = ObserverSet()
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    private var weeks: [WeekType: Week]!
    var cDayWType: (day: Day!, weekType: WeekType!){
        let cur  = TimeProvider.cDayWType
        let week = weeks[cur.weekType]!
        let day  = week.days.filter{$0.id == cur.dayID}.first!
        return (day, cur.weekType)
    }
    // ============================================================================================
    // METHODS
    // ============================================================================================
    private func updateEventTimerTick() {
        onUpdateEventTimer.notify()
    }
    // ============================================================================================
    // REQUEST
    // ============================================================================================
    func getDay(cDayID: Int, weekType: WeekType) -> Day {
        return weeks[weekType]!.days.filter{cDayID == $0.id}.first!
    }
    func getSchedule(){
        let group = GroupManager.instanse.currentGroup!
        weeks = [group.weeks[0].type : group.weeks[0], group.weeks[1].type : group.weeks[1]]
        onScheduleEvent.notify()
        updateEventTimer.start(1)
        getTimestampOfCGroupSchedule()
    }
    
    func getTimestampOfCGroupSchedule(){
        Api.instance.updateOfGroup(GroupManager.instanse.currentGroup!.id, listener: self)
    }
    // ============================================================================================
    // RESPONSE
    // ============================================================================================
    func onUpdateSchedule(updateAt: Double){
        print("newTMSP\(updateAt)")
        let cTimeStamp = Settings.scheduleUpdateTimeStamp
        if cTimeStamp == updateAt {return}
        //first load
        if cTimeStamp == 0 {
            Settings.scheduleUpdateTimeStamp = updateAt
        }
        else {
            onLoadingScheduleEvent.notify()
            GroupManager.instanse.getSchOfSelGroup(GroupManager.instanse.currentGroup!.id)
        }
    }
    
    func loadingScheduleComplite() {
        let group = GroupManager.instanse.currentGroup!
        weeks = [group.weeks[0].type : group.weeks[0], group.weeks[1].type : group.weeks[1]]
        onScheduleEvent.notify()
    }
    func loadingScheduleFailed() {
        onLoadingScheduleFailedEvent.notify()
    }
    func onUpdateScheduleFailed(){
        print("ScheduleManager.onUpdateScheduleFailed()")
    }
    func onInternetConnectionFailed() {
        print("ScheduleManager.onInternetConnectionFailed()")
        //onLoadingScheduleFailedEvent.notify()
    }
    
    
}