class Week {
    let id: Int
    let type: WeekType
    let days: [Day]
    
    init (id: Int, type: WeekType, days: [Day]) {self.id = id; self.type = type; self.days = days}
}

enum WeekType: Int {
    case ODD = 1
    case EVEN = 2
}