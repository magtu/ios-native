import UIKit

class ScheduleTableViewController: UIViewController {
    // ============================================================================================
    // FIELDS
    // ============================================================================================
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var left: NSLayoutConstraint!

    var index = 0
    var adapter = ScheduleAdapter()
    var day: Day!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.estimatedRowHeight = 86
        table.rowHeight = UITableViewAutomaticDimension
        ScheduleManager.instanse.onUpdateEventTimer.add(self, ScheduleTableViewController.onUpdateEventTimer)
        adapter.bind(table)
        left.constant = ScheduleManager.instanse.cDayWType.day == day ? 10 : 0
        adapter.loadCDay(day)
    }
    
    func onUpdateEventTimer() {
        if ScheduleManager.instanse.cDayWType.day === day {
            let t = TimeProvider.cDayTimeStamp
            let cEvent = day.events.filter{t >= $0.eventFields.startAt && t <= $0.eventFields.endAt}.first
            if let e = cEvent {
                adapter.updateCEvent(e.eventFields.indx, part: Float(t - e.eventFields.startAt) / 5400)
            }
            else  {
                adapter.rmCEvent()
            }
        }
    }
    
}

