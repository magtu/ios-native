import UIKit
import CoreData

enum DBEntytieNames: String {
    case Event = "Event"
    case Day = "Day"
    case Week = "Week"
}

class DBManager:NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    private static var fetchResultController: NSFetchedResultsController!
    static var context:NSManagedObjectContext {return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext}
    
    static func saveContext() -> Bool {
        do {
            try DBManager.context.save()
            return true
        }
        catch {
            print("EXCEPTION:" + String(error))
            return false
        }
    }
    
    static func fetchCurrentGroup() -> Group?{
        let r = NSFetchRequest(entityName: "Group")
        let fechedGroup: Group?
        do {
            fechedGroup = (try context.executeFetchRequest(r) as? [Group])?.first
        }
        catch {
            print("EXCEPTION:" + String(error))
            return nil
        }
        
        return fechedGroup
    }
    
    static func fetchGroup(id: Int) -> Group?{
        let r = NSFetchRequest(entityName: "Group")
        r.predicate = NSPredicate(format: "id_ = %d", id)
        let fechedGroup: Group
        do {
            fechedGroup = (try context.executeFetchRequest(r) as! [Group]).first!
        }
        catch {
            print("EXCEPTION:" + String(error))
            return nil
        }
        
        return fechedGroup
    }
}