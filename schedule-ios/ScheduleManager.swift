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
    
    private func onTimerTick() {
        onTimeUpdateEvent.notify()
    }
    // ============================================================================================
    // API REQUEST
    // ============================================================================================
    func getSchedule(){Api.instance.scheduleOfGroup(GroupManager.instanse.selectedGroup.id, listener: self)}
    func getUpdate(groupID:Int){Api.instance.updateOfGroup(groupID, listener: self)}
    // ============================================================================================
    // API RESPONSE
    // ============================================================================================
    func onSchedule(weeks: [WeekType: Week]){
      //  DBManager.saveContext(weeks)
        //if let fechedResult = DBManager.fetchWeeks() {
            self.weeks = weeks
            onScheduleEvent.notify()
            updateEventTimer.start(1)
    //    }
        //TODO Failed fech
        
    }
    func onUpdate(updateAt: Double){onUpdateEvent.notify(updateAt)}
}