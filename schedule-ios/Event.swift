class Event {
    let eventIndex: Int
    let courseID:Int
    let course:String
    let typeID:Int
    let type:  String
    let subgroup:Subgroups
    let teacherID:  Int
    let teacher:String
    let location:String
    
    init(eventIndex: Int, courseID: Int, course:String, typeID:Int, type:  String,subgroup:Subgroups, teacherID:  Int, teacher:String, location:String)
    {
        self.eventIndex = eventIndex
        self.courseID = courseID
        self.course = course
        self.typeID = typeID
        self.type = type
        self.subgroup = subgroup
        self.teacherID = teacherID
        self.teacher = teacher
        self.location = location
    }
}

enum Subgroups: Int {
    case BOTH   = 0
    case FIRST  = 1
    case SECOND = 2
}