import Foundation

class Schedule {
    let evenWeek: Week
    let oddWeek:  Week
    
    init(even: Week, odd: Week) {
       evenWeek = even
       oddWeek  = odd
    }
        
    subscript(type: WeekType) -> Week {
        return type == .EVEN ? evenWeek : oddWeek
    }
}