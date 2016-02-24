import Foundation
protocol Processor {
    func process(request:Request, status: ApiError, response: NSData, listener: ResponseListener)->Bool
    func processFailed(request:Request, status: ApiError, listener: ResponseListener)
}