import CoreData
@objc(Group)
class Group: NSManagedObject {
    @NSManaged var id_: Int16
    @NSManaged var name_: String
    @NSManaged var weeks_: NSOrderedSet
    
    var id: Int        {return Int(id_)}
    var name: String   {return name_}
    var weeks: [Week]  {return weeks_.array as! [Week]}
    
    convenience init (id: Int, name: String, weeks: [Week]) {
        do {
            let r = NSFetchRequest(entityName: "Group")
            let sortDescr = NSSortDescriptor(key: "id_", ascending: true)
            r.sortDescriptors = [sortDescr]
            let fechedGroups: [Group]
            do {
                    fechedGroups = try DBManager.context.executeFetchRequest(r) as! [Group]
                    fechedGroups.forEach{DBManager.context.deleteObject($0 as NSManagedObject)
                }
            }
            catch {
                print("EXCEPTION -> GROUP -> removing from db")
            }
        }
        Settings.scheduleUpdateTimeStamp = 0
        
        self.init(entity: NSEntityDescription.entityForName("Group", inManagedObjectContext:DBManager.context)!, insertIntoManagedObjectContext: DBManager.context)
        id_ = Int16(id)
        name_ = name

        
        weeks_ = NSOrderedSet(array: weeks)
        
        DBManager.saveContext()
    }
}