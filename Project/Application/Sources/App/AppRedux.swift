import Redux
import Networking
import Authentication

let store = Store<AppState, AppAction, AppEnvironment>(
    initialState: AppState(),
    reducer: Reducer { state, action, environment in
        switch action {
        case let .signUp(signUpAction):
            return Effect.empty
        }
    },
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
}

struct AppEnvironment {
    let apiClient: APIClient
    let authRepository: AuthenticationRepository
    
    var signUpEnvironment: SignUpEnvironment {
        return SignUpEnvironment(apiClient: apiClient, authRepository: authRepository)
    }
}
