import Redux
import Networking
import Authentication

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
