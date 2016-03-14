import Foundation

class ScheduleManager: ScheduleListener {
    static let instanse = ScheduleManager()
    // ============================================================================================
    // EVENTS
    // ============================================================================================
    var onScheduleEvent: ObserverSet<()>               = ObserverSet()
    var onUpdateEvent:   ObserverSet<Double>           = ObserverSet()
    var weeks: [WeekType: Week]!
    // ============================================================================================
    // EVENTS
    // ============================================================================================
    func getDay(cDayID: Int, weekType: WeekType) -> Day {
        return weeks[weekType]!.days.filter{cDayID == $0.id}.first!

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
        self.weeks = weeks
        onScheduleEvent.notify()
    }
    func onUpdate(updateAt: Double){onUpdateEvent.notify(updateAt)}
}