import Foundation

class Timer: NSObject {
    private var timer : NSTimer!
    var interval: Double
    var onTimerEvent: ObserverSet<()> = ObserverSet()
    
    init(interval: Double = 10){self.interval = interval}
    
    func start(interval: Double){
        timer = NSTimer.scheduledTimerWithTimeInterval(interval,
            target:self, selector: Selector("fire"), userInfo: nil, repeats: true)
    }
    
    func fire() {onTimerEvent.notify()}
    func stop() {timer.invalidate()}
}