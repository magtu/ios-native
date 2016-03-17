import UIKit

class EventViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var progress: UIProgressView!
    var event: Event!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func create(event: Event){
        self.event = event
        timeLabel.text = event.eventIndex.str
        nameLabel.text = event.course
        typeLabel.text = event.type
        locationLabel.text = event.location
        groupLabel.text = event.subgroup.str
        
    }
    
    func rmSeparator() {
        separator.hidden = true
    }
    
    func progressUpdate() {
       progress.progress = Float(TimeProvider.cDayTimeStamp - event.eventIndex.min) / 90.0
    }
}

