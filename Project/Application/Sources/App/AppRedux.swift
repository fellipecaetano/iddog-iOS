import Authentication
import Networking
import Redux

struct AppState: Equatable {
    var authentication = AuthenticationState()
    var signUp = SignUpState()
    var feed = FeedState()
}

enum AppAction: Equatable {
    case authentication(AuthenticationAction)
    case feed(FeedAction)
    case signUp(SignUpAction)

    var authenticationAction: AuthenticationAction? {
        switch self {
        case let .authentication(action):
            return action
        case let .signUp(.authentication(action)):
            return action
        default:
            return nil
        }
    }

    var feedAction: FeedAction? {
        switch self {
        case let .feed(action):
            return action
        default:
            return nil
        }
    }

    var signUpAction: SignUpAction? {
        switch self {
        case let .signUp(action):
            return action
        default:
            return nil
        }
    }
}

struct AppEnvironment {
    let apiClient: APIClient
    let authRepository: AuthenticationRepository
    let log: (Any) -> Void

    var authEnvironment: AuthenticationEnvironment {
        return AuthenticationEnvironment(repository: authRepository, log: log)
    }

    var signUpEnvironment: SignUpEnvironment {
        return SignUpEnvironment(apiClient: apiClient, authRepository: authRepository)
    }

    var feedEnvironment: FeedEnvironment {
        return FeedEnvironment(apiClient: apiClient, log: log)
    }
}
