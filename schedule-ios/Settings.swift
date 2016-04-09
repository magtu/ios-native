import Foundation
class Settings {
    private static let LAST_SCHEDULE_UPDATE_TIMESTAMP = "last_schedule_update_timestamp"
    private static var _scheduleUpdateTimeStamp: Double!
    static var scheduleUpdateTimeStamp: Double {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
             return Double(defaults.stringForKey(LAST_SCHEDULE_UPDATE_TIMESTAMP) ?? "0") ?? 0
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(String(newValue), forKey: LAST_SCHEDULE_UPDATE_TIMESTAMP)
            print("newTimestamp: \(newValue)")
        }
    }
}