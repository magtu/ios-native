import UIKit

class ScheduleAdapterViewController:NSObject, UITableViewDelegate, UITableViewDataSource {
    var day: Day?
    var cEventID: Int?
    var table: UITableView!
    var vc: ScheduleViewController!
    var eventCells: [EventViewCell] = []
    
    
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
            let cell = eventCells[indexPath.row-1]
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! HeaderViewCell
            cell.create(day!.name)
            return cell
        }
    }
        
    func loadCDay(){
        
        self.day = vc.cDay
        eventCells = day!.events.map{
            let c = self.table.dequeueReusableCellWithIdentifier("eventCell") as! EventViewCell
            c.create($0)
            c.progress.hidden = true
            return c
        }
        
        let e = day!.events
        if e.count > 1 {
            var ni: Int
            for i in 0 ... e.count - 2 {
                ni = i + 1
                if e[i].eventFields.0 == e[ni].eventFields.0 {
                    eventCells[i].rmSeparator()
                    eventCells[ni].rmTime()
                }
            }
        }
                
        table.reloadData()
    }
    
    func updateCEvent(id: Int, part: Float) {
        if cEventID == id {
            let e = eventCells.filter{$0.event.eventFields.indx == cEventID}.first!
            e.progress.hidden = false
            e.updateEvent(part)
        }
        else {
            eventCells.filter{$0.event.eventFields.indx == cEventID}.first?.progress.hidden = true
            cEventID = id
            let e = eventCells.filter{$0.event.eventFields.indx == cEventID}.first!
            e.progress.hidden = false
            e.updateEvent(part)
        }
    }
    func rmCEvent() {
        eventCells.filter{$0.event.eventFields.indx == cEventID}.first?.progress.hidden = true
    }
}
