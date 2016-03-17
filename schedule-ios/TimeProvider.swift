import Foundation

class TimeProvider {
   private static let date = NSDate()
   private static let calendar = NSCalendar.currentCalendar()
    
    static var cDayTimeStamp: Int {
        return calendar.components([.Hour, .Minute], fromDate: date).hour * 60 + calendar.components([.Hour, .Minute], fromDate: date).minute
    }
}