import Alamofire
import SwiftyJSON

class AlaTransport: Transport {
    let API = "api/"
    let VERSION = "v1/"
    var DOMAIN_URL = "http://xn--80agz0af.xn--p1ai/"
    let LIMIT_RESEND = 3
    var countOfResends = 0
    
    func send(request request: Request, processor: Processor, listener: ResponseListener) {        
        let url = DOMAIN_URL + API + VERSION + request.urlPath
        print(url + (request.params.isEmpty ? "" : "?" + request.params.description))
        Alamofire.request(request.command.method, url, parameters: request.params).responseJSON { response in
            
            if response.result.isFailure {print(response.result.isFailure.description)}
            else {
                if (!processor.process(
                    request,
                    response: response.data!,
                    listener: listener)
                    &&
                    (self.countOfResends <= self.LIMIT_RESEND)) {
                        sleep(1)
                        self.countOfResends += 1
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