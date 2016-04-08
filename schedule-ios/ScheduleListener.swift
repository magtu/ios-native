protocol ScheduleListener: ResponseListener {
    func onUpdate(updateAt: Double)
    func onUpdateFailed()
}