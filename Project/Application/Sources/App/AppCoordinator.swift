import UIKit
import Redux
import Networking
import Authentication

final class AppCoordinator {
    private weak var window: UIWindow?
    
    private let store = Store<AppState, AppAction, AppEnvironment>(
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
        ).debug(),
        environment: AppEnvironment(
            apiClient: APIClient.live,
            authRepository: AuthenticationRepository.live,
            log: { print($0) }
        )
    )

    init (window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        window?.rootViewController = SignUpViewController(
            store: store.scope(
                toLocalState: { $0.signUp },
                fromLocalAction: AppAction.signUp
            )
        )

        window?.makeKeyAndVisible()
    }
}
