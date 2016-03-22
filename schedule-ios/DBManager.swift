import UIKit
import CoreData

enum DBEntytieNames: String {
    case Event = "Event"
    case Day = "Day"
    case Week = "Week"
}

class DBManager:NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    private static var Weeks: [WeekType:Week]?
    private static var fetchResultController: NSFetchedResultsController!
    static var context:NSManagedObjectContext {return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext}
    
   static func saveContext() -> Bool {
        //TODO: rm old Weeks /   подмена контекстов?
        do {
            try DBManager.context.save()
            return true
        }
        catch {
            print("EXCEPTION:" + String(error))
            return false
        }
    }
    
    static func fetchWeeks() -> [WeekType: Week]?{
        let r = NSFetchRequest(entityName: "Week")
        let sortDescr = NSSortDescriptor(key: "week_id_", ascending: true)
        r.sortDescriptors = [sortDescr]
        fetchResultController = NSFetchedResultsController(fetchRequest: r, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let fechedWeeks: [Week]
        do {
            fechedWeeks = try context.executeFetchRequest(r) as! [Week]
        }
        catch {
            print("EXCEPTION:" + String(error))
            return nil
        }
        fechedWeeks.forEach{print($0.type)}
        
        return [fechedWeeks[0].type: fechedWeeks[0], fechedWeeks[1].type: fechedWeeks[1]]
    }
}