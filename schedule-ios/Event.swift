class Event {
    let eventIndex: (Int, String)
    let courseID:Int
    let course:String
    let typeID:Int
    let type:  String
    let subgroup: (Int, String)
    let teacherID:  Int
    let teacher:String
    let location:String
    
    init(eventIndex: Int, courseID: Int, course:String, typeID:Int, type:  String,subgroup:Int, teacherID:  Int, teacher:String, location:String)
    {
        self.teacherID = teacherID
        self.teacher = teacher
        self.location = location
        self.courseID = courseID
        self.course = course
        self.typeID = typeID
        self.type = type
        
        self.subgroup = {
            switch subgroup{
            case 0:  return (0, "Вся группа")
            case 1:  return (1,"1 гр.")
            case 2:  return (2,"2 гр.")
        	default: return (-1,"")
            }}()
        
        self.eventIndex = {
            switch eventIndex {
            case 1: return (1,"08:00")
            case 2: return (2,"09:40")
            case 3: return (3,"11:20")
            case 4: return (4,"13:30")
            case 5: return (5,"15:10")
            case 6: return (6,"16:50")
            case 7: return (7,"18:30")
            case 8: return (8,"20:10")
            default:return (0,"")
            }}()
    }
}

