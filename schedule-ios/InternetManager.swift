import ReachabilitySwift

public class ReachabilityHelper {
    public static var instance = ReachabilityHelper()
    public private(set) static var isReachable = false
    private let reachability: Reachability
    
    public var reachableEvent: ObserverSet<Void> = ObserverSet()
    public var unreachableEvent: ObserverSet<Void> = ObserverSet()
    
    private var reach: Reachability!
    
    init() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            fatalError("Unable to create Reachability")
        }
        
        reachability.whenReachable = { _ in
            ReachabilityHelper.isReachable = true
            self.reachableEvent.notify()
        }
        reachability.whenUnreachable = { _ in
            ReachabilityHelper.isReachable = false
            self.unreachableEvent.notify()
        }
        
        if reachability.currentReachabilityStatus != .NotReachable {
            ReachabilityHelper.isReachable = true
            self.reachableEvent.notify()
        } else {
            ReachabilityHelper.isReachable = false
            self.unreachableEvent.notify()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            fatalError("Unable to start notifier (Reachability)")
        }
    }
}