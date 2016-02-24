import SwiftyJSON

class JSONProcessor: Processor {
    func process(request:Request, status: ApiError, response: NSData, listener: ResponseListener)->Bool{
        let json = JSON(data: response)
        
        if (status != .OK) {
            return false
        }
        
        switch request.command.id {
         //   case
        }
        return true
    }
    func processFailed(request:Request, status: ApiError, listener: ResponseListener){
        
    }
}