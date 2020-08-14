import Networking

enum FeedCategory: Equatable {
    case hound
    case husky
    case pug
    case labrador

    var parameter: APIParameters.Category {
        switch self {
        case .hound:
            return .hound
        case .husky:
            return .husky
        case .pug:
            return .pug
        case .labrador:
            return .labrador
        }
    }
}
