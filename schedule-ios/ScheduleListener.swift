protocol ScheduleListener: ResponseListener {
    func onSchedule(weeks: [WeekType: Week])
    func onUpdate(updateAt: Double)
}