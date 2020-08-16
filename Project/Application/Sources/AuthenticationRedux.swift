import Authentication
import Redux
import Streams

let authReducer = Reducer<AuthenticationState, AuthenticationAction, AuthenticationEnvironment> { state, action, environment in
    switch action {
    case .read:
        return Effect<AuthenticationAction>.run { onComplete in
            do {
                let authentication = try environment.repository.get()
                onComplete(AuthenticationAction.write(authentication))
            } catch {
                environment.log(error)
            }

            return Disposable.none
        }

    case let .write(authentication):
        state.authentication = authentication
        return Effect.empty

    case let .set(authentication):
        state.authentication = authentication

        return Effect.fireAndForget {
            do {
                try environment.repository.put(authentication)
            } catch {
                environment.log(error)
            }
        }
        
    case .signOut:
        state.authentication = nil
        
        return Effect.fireAndForget {
            do {
                try environment.repository.delete()
            } catch {
                environment.log(error)
            }
        }
    }
    
}

struct AuthenticationState: Equatable {
    var authentication: Authentication? = nil
}

enum AuthenticationAction: Equatable {
    case read
    case write(Authentication)
    case set(Authentication)
    case signOut
}

struct AuthenticationEnvironment {
    let repository: AuthenticationRepository
    let log: (Any) -> Void
}
