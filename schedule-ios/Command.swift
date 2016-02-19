import Alamofire

enum Method: String {
    case GET = "GET"
    case POST = "POST"
}

class Command {
    let id: Int
    let name: String
    let method: Method
    
    init(id: Int, name: String, method: Method){
        self.id  = id
        self.name = name
        self.method = method
    }
}