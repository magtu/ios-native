class Request {
    let urlPath: String
    let command: Command
    var params = [String: String]()
    
    init(command: Command) {
        self.command = command
        urlPath = command.name
    }
    init(command: Command, urlPaths: [String]){
        self.command = command
        urlPath = command.name + urlPaths.map { return }
    }
    func addParam(key: String, value: String) {
        params[key] = value
    }
    
    func getParam(key: String) -> String {
        return params[key]!
    }
}