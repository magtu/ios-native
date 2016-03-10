import Foundation
protocol Processor {
    func process(request:Request, response: NSData, listener: ResponseListener)->Bool
    func processFailed(request:Request, listener: ResponseListener)
}