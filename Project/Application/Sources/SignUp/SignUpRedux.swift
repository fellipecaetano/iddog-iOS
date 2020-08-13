import Authentication
import Networking
import Redux

let signUpReducer = Reducer<SignUpState, SignUpAction, SignUpEnvironment> { state, action, environment in
    switch action {
    case let .signUp(email):
        state.isInProgress = false

        return environment.apiClient.signUp(email)
            .map { result in
                switch result {
                case .success:
                    return SignUpAction.succeed
                case .failure:
                    return SignUpAction.fail
                }
            }
            .eraseToEffect()
    case .succeed:
        state.isInProgress = false
        return Effect.empty
    case .fail:
        state.isInProgress = false
        return Effect.empty
    }
}

struct SignUpState: Equatable {
    var isInProgress = false
}

enum SignUpAction: Equatable {
    case signUp(email: String)
    case succeed
    case fail
}

struct SignUpEnvironment {
    let apiClient: APIClient
    let authRepository: AuthenticationRepository
}
