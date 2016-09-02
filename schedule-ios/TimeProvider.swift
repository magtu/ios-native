import Foundation

class TimeProvider {
    private static var today : NSDate {return NSDate()}
    private static var calendar: NSCalendar = {
        let c = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)!
        c.timeZone = NSTimeZone(abbreviation: "UTC")!
        c.firstWeekday = 2
        return c
    }()
    private static let startWeekNumber = 33
    
    private static var f: NSDateFormatter = {
    let f = NSDateFormatter()
    f.calendar = calendar
    f.timeStyle = .MediumStyle
    return f}()
    
    static var cDayTimeStamp: Int {
        let dateComponent = calendar.components([.Hour, .Minute, .Second], fromDate: today) 
        return (dateComponent.hour + 5) * 3600 + dateComponent.minute * 60 + dateComponent.second
    }
    //TODO: CHECK ON DEVICE
    static var cDayWType: (dayID: Int, weekType: WeekType) {
        let dateComponent = calendar.components([.WeekOfYear, .Weekday], fromDate: today)
        
        let wT : WeekType = abs(startWeekNumber - dateComponent.weekOfYear) % 2 == 0 ? .EVEN : .ODD
       let d = dateComponent.weekday == 1 ? 7 : dateComponent.weekday - 1
        return (d, wT)
    }
}