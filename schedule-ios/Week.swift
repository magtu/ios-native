import CoreData

class Week: NSManagedObject {
    @NSManaged private var week_id_: Int16
    @NSManaged private var week_: String
    @NSManaged private var days_: NSOrderedSet
    
    var id  : Int      {return Int(week_id_)}
    var type: WeekType {return week_id_ == 1 ? .ODD : .EVEN}
    var days: [Day]    {return days_.array as! [Day]}
    
    convenience init (id: Int, type: WeekType, days: [Day]) {
        self.init(entity: NSEntityDescription.entityForName("Week", inManagedObjectContext:DBManager.context)!, insertIntoManagedObjectContext: DBManager.context)
        week_id_ = Int16(id)
        days_ = NSOrderedSet(array: days)
        week_ = type.rawValue
    }
}

enum WeekType: String {
    case ODD = "Нечетная"
    case EVEN = "Четная"
}