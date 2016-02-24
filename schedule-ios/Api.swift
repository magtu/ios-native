import Alamofire

class Api {
    
    //============================================================================================
    // FIELDS
    //============================================================================================
    static let instance = Api()
    private let alaTransport = AlaTransport()
    private let jsonProcessor = JSONProcessor()
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

    func send(request r: Request, listener l: ResponseListener) {
        send(request: r, listener: l, transport: alaTransport, processor: jsonProcessor)
    }
    
    func send(request r: Request, listener l: ResponseListener, transport t: Transport, processor p: Processor){
        t.send(request: r, processor: p, listener: l)
    }

    func groups(listener l: ResponseListener) {
        let r = Request(command: Api.GROUPS)
        send(request: r, listener: l)
    }
    
    func groups(groupName: String, listener l: ResponseListener) {
        let r = Request(command: Api.GROUPS)
        r.addParam("q", value: groupName)
        send(request: r, listener: l)
    }
    
    func scheduleOfGroup(groupID: Int,  listener l: ResponseListener) {
        let r = Request(command: Api.SCHEDULE, urlPaths: [groupID.description])
        send(request: r, listener: l)
    }
    
    func updateOfGroup(groupID: Int,  listener l: ResponseListener) {
        let r = Request(command: Api.UPDATE_OF_SCHEDULE, urlPaths: [groupID.description])
        send(request: r, listener: l)
    }
}