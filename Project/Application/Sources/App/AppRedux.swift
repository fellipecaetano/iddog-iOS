import Redux
import Networking
import Authentication

struct AppState: Equatable {
    var authentication = AuthenticationState()
    var signUp = SignUpState()
}

enum AppAction: Equatable {
    case authentication(AuthenticationAction)
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
    
    var authEnvironment: AuthenticationEnvironment {
        return AuthenticationEnvironment(repository: authRepository)
    }

    var signUpEnvironment: SignUpEnvironment {
        return SignUpEnvironment(apiClient: apiClient, authRepository: authRepository)
    }
}
