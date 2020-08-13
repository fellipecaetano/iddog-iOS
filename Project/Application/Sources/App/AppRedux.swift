import Redux
import Networking
import Authentication

let store = Store<AppState, AppAction, AppEnvironment>(
    initialState: AppState(),
    reducer: Reducer.combine(
        authReducer.pullback(
            state: \AppState.authentication,
            toAction: { $0.authenticationAction },
            fromAction: AppAction.authentication,
            environment: { $0.authEnvironment }
        ),
        signUpReducer.pullback(
            state: \AppState.signUp,
            toAction: { $0.signUpAction },
            fromAction: AppAction.signUp,
            environment: { $0.signUpEnvironment}
        )
    ),
    environment: AppEnvironment(
        apiClient: APIClient.live,
        authRepository: AuthenticationRepository.live
    )
)

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
