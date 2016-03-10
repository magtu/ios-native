protocol GroupsListner: ResponseListener {
    func onGroups(groups: [Group])
    func onGroupsFailed()
}