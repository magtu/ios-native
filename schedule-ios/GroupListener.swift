protocol GroupsListner: ResponseListener {
    func onGroups(groups: [SearchingGroup])
    func onGroupsFailed()
    func onGetSchOfSelGroup(groups: Group)
}