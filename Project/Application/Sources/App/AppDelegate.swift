import UIKit
import Redux
import Networking
import Authentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
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
            authRepository: AuthenticationRepository.live
        )
    )

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SignUpViewController(
            store: store.scope(
                toLocalState: { $0.signUp },
                fromLocalAction: AppAction.signUp
            )
        )
        window?.makeKeyAndVisible()
        return true
    }
}
