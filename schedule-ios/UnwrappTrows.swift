import Foundation
public enum UnwrapError: ErrorType {
    case NilValue
}

postfix operator ~! { }
postfix func ~! <T> (params: T?) throws -> T {
    if let res = params {
        return res
    } else {
        throw UnwrapError.NilValue
    }
}