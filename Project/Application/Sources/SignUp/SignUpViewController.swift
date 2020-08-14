import Authentication
import Networking
import Redux
import Streams
import UIKit

class SignUpViewController: UIViewController {
    private let store: AnyStore<SignUpState, SignUpAction>
    private let disposeBag = DisposeBag()

    init(store: AnyStore<SignUpState, SignUpAction>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = SignUpView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        smartView.signUpButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @objc private func signIn() {
        let email = smartView.emailTextField.text ?? ""
        store.emit(.signUp(email: email))
    }
}

extension SignUpViewController {
    fileprivate var smartView: SignUpView! {
        return view as? SignUpView
    }
}
