import Alamofire

class AlaTransport: Transport {
    let API = "api/"
    let VERSION = "v1/"
    var DOMAIN_URL = "http://xn--80agz0af.xn--p1ai/"
    let LIMIT_RESEND = 3
    var countOfResends = 0
    
    func send(request request: Request, processor: Processor, listener: ResponseListener) {
        let url = DOMAIN_URL + API + VERSION + request.urlPath
        
        Alamofire.request(request.command.method, url, parameters: request.params).response { _, response, data, error in
            if error != nil {print(error!.localizedDescription)}
            else {
                if (!processor.process(request, status: ApiError(rawValue:response?.statusCode ?? ApiError.WTF.rawValue)!, response: data!, listener: listener)
                    && (self.countOfResends <= self.LIMIT_RESEND)) {
                    sleep(1)
                    self.countOfResends++
                    self.send(request: request, processor: processor, listener: listener)
                }
                else {
                    //Все пиздец
                    self.countOfResends = 0
                }
            }
        }
    }
    
}