import Authentication
import Redux

let authReducer = Reducer<AuthenticationState, AuthenticationAction, AuthenticationEnvironment> { state, action, environment in
    switch action {
    case let .signUp(.succeed(authentication)):
        state.authentication = authentication
    default:
        break
    }
    return Effect.empty
}

struct AuthenticationState: Equatable {
    var authentication: Authentication? = nil
}

enum AuthenticationAction: Equatable {
    case signUp(SignUpAction)
}

struct AuthenticationEnvironment {
    let repository: AuthenticationRepository
}
