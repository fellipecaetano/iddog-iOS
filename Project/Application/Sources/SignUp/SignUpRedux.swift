import Authentication
import Networking
import Redux
import Streams

let signUpReducer = Reducer<SignUpState, SignUpAction, SignUpEnvironment> { state, action, environment in
    switch action {
    case let .signUp(email):
        state.isInProgress = true

        return environment.apiClient.signUp(email)
            .flatMap { result in
                switch result {
                case let .success(response):
                    let auth = Authentication(email: response.user.email, token: response.user.token)

                    return Observables.of(
                        SignUpAction.succeed(auth: auth),
                        SignUpAction.authentication(.authenticate(auth))
                    )
                case .failure:
                    return Observables.just(SignUpAction.fail)
                }
            }
            .eraseToEffect()
    case .succeed:
        state.isInProgress = false
        return Effect.empty
    case .fail:
        state.isInProgress = false
        return Effect.empty
    case .authentication:
        return Effect.empty
    }
}

struct SignUpState: Equatable {
    var isInProgress = false
}

enum SignUpAction: Equatable {
    case signUp(email: String)
    case succeed(auth: Authentication)
    case authentication(AuthenticationAction)
    case fail
}

struct SignUpEnvironment {
    let apiClient: APIClient
    let authRepository: AuthenticationRepository
}
