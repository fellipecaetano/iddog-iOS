import UIKit
import Redux
import Networking
import Authentication
import Streams

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
            feedReducer.pullback(
                toAction: { $0.feedAction },
                fromAction: AppAction.feed,
                environment: { $0.feedEnvironment }
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
    
    private var disposeBag = DisposeBag()

    init (window: UIWindow?) {
        self.window = window
    }

    func start() {
        store.emit(AppAction.authentication(.read))

        store
            .map { $0.authentication }
            .distinctUntilChanged()
            .subscribe { [weak self] authState in
                self?.onAuthentication(authState.authentication)
            }
            .disposed(by: disposeBag)

        window?.makeKeyAndVisible()
    }

    private func onAuthentication(_ authentication: Authentication?) {
        if authentication == nil {
            UIView.transition(
                with: window!,
                duration: 0.5,
                options: [.transitionFlipFromRight],
                animations: {
                    self.window?.rootViewController = SignUpViewController(
                        store: self.store.scope(
                            toLocalState: { $0.signUp },
                            fromLocalAction: AppAction.signUp
                        )
                    )
                }
            )
        } else {
            UIView.transition(
                with: window!,
                duration: 0.5,
                options: [.transitionFlipFromLeft],
                animations: {
                    self.window?.rootViewController = FeedViewController(
                        store: self.store.scope(
                            toLocalState: { $0.feed },
                            fromLocalAction: AppAction.feed
                        )
                    )
                }
            )
        }
    }
}
