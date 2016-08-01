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
        
        let group = GroupManager.instanse.currentGroup!
        schedule = Schedule(even: group.weeks[1], odd: group.weeks[0])
        
        updateEventTimer.start(1)
        getTimestampOfCGroupSchedule()
    }
    // ============================================================================================
    // EVENTS
    // ============================================================================================
    var onLoadingScheduleEvent: ObserverSet<()> = ObserverSet()
    var onScheduleEvent: ObserverSet<()> = ObserverSet()
    var onLoadingScheduleFailedEvent: ObserverSet<()> = ObserverSet()
    
    var onUpdateEventTimer: ObserverSet<()> = ObserverSet()
    var onInternetConnectionEventFailed: ObserverSet<()> = ObserverSet()
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    private var schedule: Schedule!
    var cDayWType: (day: Day!, weekType: WeekType!){
        let cur  = TimeProvider.cDayWType
        let week = schedule[cur.weekType]
        let day  = week.days.filter{$0.id == cur.dayID}.first!
        return (day, cur.weekType)
    }
    // ============================================================================================
    // METHODS
    // ============================================================================================
    private func updateEventTimerTick() {
        onUpdateEventTimer.notify()
    }
    private func getTimestampOfCGroupSchedule(){
        Api.instance.updateOfGroup(GroupManager.instanse.currentGroup!.id, listener: self)
    }
    // ============================================================================================
    // REQUEST
    // ============================================================================================
    func getDay(cDayID: Int, weekType: WeekType) -> Day {
        return schedule[weekType].days.filter{cDayID == $0.id}.first!
    }
    // ============================================================================================
    // RESPONSE
    // ============================================================================================
    private var updatetmstp: Double?
    func onUpdateSchedule(updateAt: Double){
        print("serverTMSP: \(updateAt)")
        let cTimeStamp = Settings.scheduleUpdateTimeStamp
        if cTimeStamp == updateAt {return}
        //first load
        if cTimeStamp == 0 {
            Settings.scheduleUpdateTimeStamp = updateAt
        }
        else {
            updatetmstp = updateAt
            onLoadingScheduleEvent.notify()
            GroupManager.instanse.getSchOfSelGroup(GroupManager.instanse.currentGroup!.id,
                                                   name: GroupManager.instanse.currentGroup!.name)
        }
    }
    
    func loadingScheduleComplite() {
        if updatetmstp != nil {
            Settings.scheduleUpdateTimeStamp = updatetmstp!
            updatetmstp = nil
            onScheduleEvent.notify()
        }
    }
    func loadingScheduleFailed() {
        if updatetmstp != nil {
            updatetmstp = nil
            onLoadingScheduleFailedEvent.notify()
        }
    }
    func onUpdateScheduleFailed(){
        print("ScheduleManager.onUpdateScheduleFailed()")
    }
    func onInternetConnectionFailed() {
        print("ScheduleManager.onInternetConnectionFailed()")
        //onLoadingScheduleFailedEvent.notify()
    }
    
    
}