import Alamofire
import SwiftyJSON

class AlaTransport: Transport {
    let API = "api/"
    let VERSION = "v1/"
    var DOMAIN_URL = "http://xn--80agz0af.xn--p1ai/"
    let LIMIT_RESEND = 2
    var countOfResends = 0
    
    func send(request request: Request, processor: Processor, listener: ResponseListener) {
        if !InternetManager.isConnectedToNetwork() {
            listener.onInternetConnectionFailed()
            return
        }
        let url = DOMAIN_URL + API + VERSION + request.urlPath
        print(url + (request.params.isEmpty ? "" : "?" + request.params.description))
        Alamofire.request(request.command.method, url, parameters: request.params).response { (_,_httpResponce,_data,_error) in
            if !processor.process(request, response: _data!, listener: listener) {
                if (self.countOfResends < self.LIMIT_RESEND) {
                    self.countOfResends += 1
                    self.send(request: request, processor: processor, listener: listener)
                } else {
                    //Все пиздец
                    self.countOfResends = 0
                    processor.processFailed(request, listener: listener)
                }
            }
        }
    }
}
