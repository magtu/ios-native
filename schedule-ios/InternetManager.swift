import Foundation
import ReachabilitySwift

class InternetManager {
    static var onInternetConnectEvent = ObserverSet<Void>()
    static var onInternetDisconectEvent = ObserverSet<Void>()
    
    static private var reachability:Reachability!
    
    class func creat() {
        do {
            InternetManager.reachability = try Reachability.reachabilityForInternetConnection()
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: #selector(InternetManager.reachabilityChanged(_:)),
                name: ReachabilityChangedNotification,object: InternetManager.reachability)
            
            try InternetManager.reachability.startNotifier()
        }
        catch {
            print("EXCEPTION: INTERNET MANAGER CREATE()")
        }
    }
    
    
    @objc class func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            InternetManager.isConnectedToNetwork() ?
                InternetManager.onInternetConnectEvent.notify() :
                InternetManager.onInternetDisconectEvent.notify()
        } else {
            InternetManager.onInternetDisconectEvent.notify()
        }
    }
    
    class func isConnectedToNetwork()->Bool{
        var Status = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        do {
            try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData?
        }
        catch {}
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        return Status
    }
}
