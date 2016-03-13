import UIKit

class EventViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    var event: Event!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func create(event: Event){
        self.event = event
        timeLabel.text = event.eventIndex.1
        nameLabel.text = event.course
        typeLabel.text = event.type
        groupLabel.text = event.subgroup.1
        
    }
}

