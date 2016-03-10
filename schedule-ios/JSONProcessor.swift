import SwiftyJSON

class JSONProcessor: Processor {
    func process(request:Request, response: NSData, listener: ResponseListener)->Bool{
        let response = JSON(data: response)
        
        do {
            switch request.command.id {
            case Api.GROUPS.id:
                try groups(response, listener: listener as! GroupListner)
            case Api.SCHEDULE.id:
                try schedule(response, listener: listener as! ScheduleListener)
            case Api.UPDATE_OF_SCHEDULE.id:
                try update(response, listener: listener as! ScheduleListener)
                
            default:break
            }
        }
        catch UnwrapError.NilValue { return false }
        catch { return false }
        
        return true
    }
    func processFailed(request:Request,  listener: ResponseListener){
        
    }
    
    // ============================================================================================
    // 01. GROUPS
    // ============================================================================================
    func groups(json: JSON, listener: GroupListner) throws {
        let groups = try json.map{_, g in Group(id: try g["id"].int~!, name: try g["name"].string~!)}
        listener.onGroup(groups)
    }
    // ============================================================================================
    // 02. SCHEDULE
    // ============================================================================================
    func schedule(json: JSON, listener: ScheduleListener) throws {
        let schedule = try json.map{_, w in
            Week(id:try w["week_id"].int~!,
                type: try {
                    let weekName = try w["week"].string~!
                    switch weekName {
                    case "Нечетная":
                        return .ODD
                    case   "Четная":
                        return .EVEN
                    default : fatalError("Bad format of week name")
                    }
                    }(),
                days: try w["days"].map {_,d in//ХУЙНЯ
                        Day(id: try d["day_id"].int~!, name: try d["day"].string~!,
                            events: try {
                                let events = try d["events"].events~!
                                return events
                                }()
                        )
                })}
        listener.onSchedule([schedule[0].type : schedule[0], schedule[1].type : schedule[1]])
    }
// ============================================================================================
// 03. UPDATE
// ============================================================================================
func update(json: JSON, listener: ScheduleListener) throws {
    listener.onUpdate(try json["updated_at"].double~!)
    }
}

extension JSON {
    var events: [Event]? {
        do {
            return (try self.map {_, j in
                return Event(eventIndex: try j["event_index"].int~! ,
                               courseID: try j["course_id"].int~!,
                                 course: try j["course"].string~!,
                                 typeID: try j["type_id"].int~!,
                                   type: try j["type"].string~!,
                               subgroup: Subgroups(rawValue: try  j["subgroup"].int~!)!,
                              teacherID: try j["teacher_id"].int~!,
                                teacher: try j["teacher"].string~!,
                               location: try j["location"].string~!)})
        }
        catch {
            return nil
        }
    }
}









