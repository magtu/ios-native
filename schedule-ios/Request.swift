import Foundation

class Request {

    let command: Command
    let urlPath: String

    var params = [String: String]()
    
    init(command: Command) {
        self.command = command
        urlPath = command.name
    }
    init(command: Command, urlPaths: [String]){
        self.command = command
        urlPath = NSString(format:command.name, urlPaths[0]) as String
    }
    
    func addParam(key: String, value: String) {
        params[key] = value
    }
    
    func getParam(key: String) -> String {
        return params[key]!
    }
}