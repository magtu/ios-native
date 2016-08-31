import UIKit

class EventViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var teacherNameLabel: UILabel!
    var event: Event!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func create(event: Event){
        self.event = event
        timeLabel.text = event.eventFields.StartStr
        endTimeLabel.text = event.eventFields.EndStr        
        nameLabel.text = event.course
        typeLabel.text = event.type
        locationLabel.text = event.location
        groupLabel.text = event.subgroup.str
        teacherNameLabel.text = event.teacher
        
        timeLabel.hidden = false
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 5
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    func rmTime() {
        timeLabel.hidden = true
    }
    func updateEvent(part: Float) {
        progress.progress = part
    }
}

