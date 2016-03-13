import Foundation

class ScheduleManager: ScheduleListener {
    let instance = ScheduleManager()
    // ============================================================================================
    // EVENTS
    // ============================================================================================
    var onScheduleEvent: ObserverSet<[WeekType: Week]> = ObserverSet()
    var   onUpdateEvent: ObserverSet<Double>           = ObserverSet()
    // ============================================================================================
    // API REQUEST
    // ============================================================================================
    func getSchedule(groupID:Int){Api.instance.scheduleOfGroup(groupID, listener: self)}
    func getUpdate(groupID:Int){Api.instance.updateOfGroup(groupID, listener: self)}
    // ============================================================================================
    // API RESPONSE
    // ============================================================================================
    func onSchedule(weeks: [WeekType: Week]){onScheduleEvent.notify(weeks)}
    func onUpdate(updateAt: Double){onUpdateEvent.notify(updateAt)}
}