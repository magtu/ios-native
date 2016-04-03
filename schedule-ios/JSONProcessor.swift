import SwiftyJSON

class JSONProcessor: Processor {
    func process(request:Request, response: NSData, listener: ResponseListener)->Bool{
        let response = JSON(data: response)
       // print(response)
        do {
            switch request.command.id {
            case Api.GROUPS.id:
                try groups(response, listener: listener as! GroupsListner)
            case Api.SCHEDULE.id:
                try schedule(response, listener: listener as! GroupsListner)
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
    func groups(json: JSON, listener: GroupsListner) throws {
        let groups = try json.map{_, g in SearchingGroup(id: try g["id"].int~!, name: try g["name"].string~!)}
        listener.onGroups(groups)
    }
    // ============================================================================================
    // 02. SCHEDULE
    // ============================================================================================
    func schedule(json: JSON, listener: GroupsListner) throws {
        listener.onGetSchOfSelGroup( 
            Group(
            id: GroupManager.instanse.selectedSearchingGroup.id,
            name: GroupManager.instanse.selectedSearchingGroup.name,
            weeks: try json.weeks~!)
        )
    }
// ============================================================================================
// 03. UPDATE
// ============================================================================================
func update(json: JSON, listener: ScheduleListener) throws {
    listener.onUpdate(try json["updated_at"].double~!)
    }
}

extension JSON {
    var weeks: [Week]? {
        do {
            return (try self.map{_, j in
                Week(id:try j["week_id"].int~!,
                    type: try {
                        let weekName = try j["week"].string~!
                        switch weekName {
                        case "Нечетная":
                            return .ODD
                        case   "Четная":
                            return .EVEN
                        default : fatalError("Bad format of week name")
                       }
                }(),
                    days: try j["days"].days~!
                )
            }
            )
        }
        catch {
            print("EXCEPTION: json -> weeks")
            return nil
        }
    }
    
    var days: [Day]?{
        do {
            return (try self.map {_,j in
                return Day(id: try j["day_id"].int~!,
                           name: try j["day"].string~!,
                           events: try {
                            let events = try j["events"].events~!
                            return events
                        }()
                )
                })
        }
        catch {
            print("EXCEPTION: json -> days")
            return nil
        }
    }
    var events: [Event]? {
        do {
            return (try self.map {_, j in
                return Event(eventIndex: try j["event_index"].int~!,
                               courseID: try j["course_id"].int~!,
                                 course: try j["course"].string~!,
                                 typeID: try j["type_id"].int~!,
                                   type: try j["type"].string~!,
                               subgroup: try j["subgroup"].int~!,
                              teacherID: try j["teacher_id"].int~!,
                                teacher: try j["teacher"].string~!,
                               location: try j["location"].string~!)})
        }
        catch {
            print("EXCEPTION: json -> events")
            return nil
        }
    }
}









