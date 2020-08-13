import Authentication
import Redux

let authReducer = Reducer<AuthenticationState, AuthenticationAction, AuthenticationEnvironment> { state, action, environment in
    switch action {
    case let .authenticate(authentication):
        state.authentication = authentication

        return Effect.fireAndForget {
            do {
                try environment.repository.put(authentication)
            } catch {
                print(error)
            }
        }
    default:
        return Effect.empty
    }
}

struct AuthenticationState: Equatable {
    var authentication: Authentication? = nil
}

enum AuthenticationAction: Equatable {
    case authenticate(Authentication)
}

struct AuthenticationEnvironment {
    let repository: AuthenticationRepository
}
