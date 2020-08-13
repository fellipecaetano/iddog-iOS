import Redux
import Networking
import Authentication

let store = Store<AppState, AppAction, AppEnvironment>(
    initialState: AppState(),
    reducer: Reducer.combine(
        signUpReducer.pullback(
            state: \AppState.signUp,
            toAction: { $0.signUpAction },
            fromAction: AppAction.signUp,
            environment: { $0.signUpEnvironment
        })
    ),
    environment: AppEnvironment(
        apiClient: APIClient.live,
        authRepository: AuthenticationRepository.live
    )
)

struct AppState: Equatable {
    var signUp = SignUpState()
}

enum AppAction: Equatable {
    case signUp(SignUpAction)
    
    var signUpAction: SignUpAction? {
        switch self {
        case let .signUp(action):
            return action
        }
    }
}

struct AppEnvironment {
    let apiClient: APIClient
    let authRepository: AuthenticationRepository
    
    var signUpEnvironment: SignUpEnvironment {
        return SignUpEnvironment(apiClient: apiClient, authRepository: authRepository)
    }
}
