import UIKit

class ScheduleAdapterViewController:NSObject, UITableViewDelegate, UITableViewDataSource {
   var day: Day?
   var table: UITableView!
   var vc: ScheduleViewController!
   var listOfSeparatorsToDelete: [Int] = []
    
    func bind(table: UITableView, vc: ScheduleViewController) {
        self.table = table
        table.dataSource = self
        table.delegate = self
        self.vc = vc
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if day != nil {return day!.events.count + 1 } else {return 0}
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row != 0  {
                let cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as! EventViewCell
                let row = indexPath.row - 1
                    cell.create(day!.events[row])
            if listOfSeparatorsToDelete.contains(row) {
                cell.rmSeparator()
            }
            
                return cell
        } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! HeaderViewCell
                cell.create(day!.name)
                return cell
        }
    }

    func loadCDay(){
        self.day = vc.cDay
        listOfSeparatorsToDelete.removeAll()
        
        let e = day!.events
        if !e.isEmpty{
            var ni: Int
            for i in 0 ... e.count - 2 {
                ni = i + 1
                if e[i].eventIndex.0 == e[ni].eventIndex.0 {
                    listOfSeparatorsToDelete.append(i)}
                
            }
            
        }
        
        table.reloadData()
    }
    
    func deleteSeparatorIfNeed(cell: EventViewCell, row: Int) {
        //TODO
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
