import CoreData

class Day : NSManagedObject{
    @NSManaged var day_id_: Int16
    @NSManaged var day_   : String
    @NSManaged var events_: NSOrderedSet
    
    var id: Int  {return Int(day_id_)}
    var name: String {return day_}
    var events: [Event] {return events_.array as! [Event]}
    
   convenience init(id: Int, name: String, events: [Event]){
        self.init(entity: NSEntityDescription.entityForName("Day", inManagedObjectContext:DBManager.context)!, insertIntoManagedObjectContext: DBManager.context)
        day_id_ = Int16(id)
        day_ = name
        events_ = NSOrderedSet(array: events.sort{$0.0.eventFields.indx < $0.1.eventFields.indx})
    }
}
