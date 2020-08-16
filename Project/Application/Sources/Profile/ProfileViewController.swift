import Redux
import Streams
import UIKit

final class ProfileViewController: UIViewController {
    private let store: AnyStore<AuthenticationState, AuthenticationAction>
    private let disposeBag = DisposeBag()

    init(store: AnyStore<AuthenticationState, AuthenticationAction>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(
            title: L10n.profile,
            image: Asset.profileTabBarIcon.image,
            selectedImage: Asset.profileTabBarIcon.image
        )
        title = L10n.profile
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ProfileView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        store.map { $0.authentication?.email }
            .bind(to: smartView.emailLabel.streams.text)
            .disposed(by: disposeBag)
        
        smartView.signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }

    @objc private func signOut() {
        store.emit(.signOut)
    }
}

extension ProfileViewController {
    var smartView: ProfileView! {
        return view as? ProfileView
    }
}
