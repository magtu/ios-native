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
        timeLabel.text = event.eventFields.str
        nameLabel.text = event.course
        typeLabel.text = event.type.lowercaseString
        locationLabel.text = event.location
        groupLabel.text = event.subgroup.str
        separator.hidden = false
        timeLabel.hidden = false
    }
    
    func rmSeparator() {
        separator.hidden = true
    }
    func rmTime() {
        timeLabel.hidden = true
    }
    func updateEvent(part: Float) {
        progress.progress = part
    }
}

