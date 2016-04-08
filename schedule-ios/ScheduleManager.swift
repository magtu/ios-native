import Foundation
import CoreData

class ScheduleManager: ScheduleListener {
    static let instanse = ScheduleManager()
    let updateEventTimer = Timer()
    init() {
        updateEventTimer.onTimerEvent.add(self, ScheduleManager.onTimerTick)
    }
    // ============================================================================================
    // EVENTS
    // ============================================================================================
    var onScheduleEvent: ObserverSet<()>     = ObserverSet()
    var onUpdateEvent:   ObserverSet<Double> = ObserverSet()
    var onTimeUpdateEvent: ObserverSet<()>   = ObserverSet()
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
    func getDay(cDayID: Int, weekType: WeekType) -> Day {
        return weeks[weekType]!.days.filter{cDayID == $0.id}.first!
    }
    func onUpdateFailed(){}
    private func onTimerTick() {
        onTimeUpdateEvent.notify()
    }
    func getSchedule(){
        let group = GroupManager.instanse.currentGroup!
        weeks = [group.weeks[0].type : group.weeks[0], group.weeks[1].type : group.weeks[1]]
        onScheduleEvent.notify()
        updateEventTimer.start(1)
    }
    
    func getUpdate(groupID:Int){Api.instance.updateOfGroup(groupID, listener: self)}
    func onUpdate(updateAt: Double){onUpdateEvent.notify(updateAt)}
    func onInternetConnectionFailed() {
        
    }
}