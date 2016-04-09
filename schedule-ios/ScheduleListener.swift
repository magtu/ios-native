protocol ScheduleListener: ResponseListener {
    func onUpdateSchedule(updateAt: Double)
    func onUpdateScheduleFailed()
}