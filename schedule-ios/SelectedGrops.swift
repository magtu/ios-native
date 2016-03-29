import Foundation
import CoreData

class SelectedGroups: NSManagedObject {
    @NSManaged var groups_: NSOrderedSet
    @NSManaged var currentGroup_: Int16
    
    var groups: [Group] {return groups_.array as! [Group]}
    var cGroup: Int     {return Int(currentGroup_)}
    
    convenience init (selectedGroups: [Group], cGroupID: Int) {
        self.init(entity: NSEntityDescription.entityForName("SelectedGroups", inManagedObjectContext:DBManager.context)!, insertIntoManagedObjectContext: DBManager.context)
        groups_ = NSOrderedSet(array: selectedGroups)
        currentGroup_ = Int16(cGroupID)
        DBManager.saveContext()
    }
}