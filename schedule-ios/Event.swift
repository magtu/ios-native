import CoreData

class Event: NSManagedObject {
    @NSManaged var event_index_: Int16
    @NSManaged var course_id_: Int16
    @NSManaged var course_: String
    @NSManaged var type_id_: Int16
    @NSManaged var type_: String
    @NSManaged var subgroup_: Int16
    @NSManaged var teacher_id_: Int16
    @NSManaged var teacher_: String
    @NSManaged var location_: String
    
    var eventFields: (indx:Int, str:String, startAt:Int, endAt: Int) {
        switch event_index_ {
        case 1: return (1,"08:00", 28800, 34200)
        case 2: return (2,"09:40", 34800, 40200)
        case 3: return (3,"11:20", 40800, 46200)
        case 4: return (4,"13:30", 48600, 54000)
        case 5: return (5,"15:10", 54600, 60000)
        case 6: return (6,"16:50", 60600, 66000)
        case 7: return (7,"18:30", 66600, 72000)
        case 8: return (8,"20:10", 72600, 78000)
        default:return (0,"",0,0)
        }
    }
    var subgroup: (indx:Int, str:String) {
        switch subgroup_{
        case 0:  return (0, "Вся группа")
        case 1:  return (1,"1 гр.")
        case 2:  return (2,"2 гр.")
        default: return (-1,"")
        }
    }
    var courseID:Int {return Int(course_id_)}
    var course:String {return course_}
    var typeID:Int {return Int(type_id_)}
    var type:String {return type_}
    var teacherID: Int {return Int(teacher_id_)}
    var teacher:String {return teacher_}
    var location:String {return location_}
    
    
  convenience  init(eventIndex: Int, courseID: Int, course: String, typeID: Int,
        type: String, subgroup:Int, teacherID: Int, teacher: String, location: String)
    {
        self.init(entity: NSEntityDescription.entityForName("Event", inManagedObjectContext:DBManager.context)!, insertIntoManagedObjectContext: DBManager.context)
        event_index_ = Int16(eventIndex)
        teacher_id_ = Int16(teacherID)
        teacher_ = teacher
        subgroup_ = Int16(subgroup)
        location_ = location
        course_id_ = Int16(courseID)
        course_ = course
        type_id_ = Int16(typeID)
        type_ = type//String(type.characters.prefix(1)).uppercaseString + String(type.characters.dropFirst())
    }
}