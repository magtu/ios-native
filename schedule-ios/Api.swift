
class Api {
    //============================================================================================
    // 1 Группы
    //============================================================================================
    static let GROUPS = Command(id: 10, name: "groups", method: .GET)
    //============================================================================================
    // 2  Расписание
    //============================================================================================
    static let SCHEDULE = Command(id: 20, name: "groups/%@/schedule", method: .GET)
    //============================================================================================
    // 3 Обновления
    //============================================================================================
    static let UPDATE_OF_SCHEDULE = Command(id: 30, name: "groups/%@/updates/schedule", method: .GET)
    
    
    
    //============================================================================================
    // SEND
    //============================================================================================

    func send(request: Request, listner: ResponceListner) {
        
    }
    

    func groups() {
        
    }
    
    func groups(groupName: String, listner l: ResponceListner) {
        let r = Request(command: Api.GROUPS)
        send(r, listner: l)
    }
    
    func scheduleOfGroup(id: Int) {
        
    }
    
    func updateOfGroup(id: Int) {
        
    }
}