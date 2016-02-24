protocol GroupListner: ResponseListener {
    func onGroup()
    func onGroupFailed()
}