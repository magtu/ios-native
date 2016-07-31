import Foundation

class Schedule {
    let evenWeek: Week
    let oddWeek:  Week
    
    init(even: Week, odd: Week) {
       evenWeek = even
       oddWeek  = odd
    }
}