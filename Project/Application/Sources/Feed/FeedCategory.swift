import Networking

enum FeedCategory: String, Equatable, CaseIterable {
    case hound
    case husky
    case pug
    case labrador

    var title: String {
        return rawValue.capitalized
    }

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
