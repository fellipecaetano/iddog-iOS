import Authentication
import Networking
import Redux
import Streams
import UIKit

class SignUpViewController: UIViewController {
    private let store: AnyStore<SignUpState, SignUpAction>
    private let viewModel: SignUpViewModel
    private let disposeBag = DisposeBag()

    init(store: AnyStore<SignUpState, SignUpAction>) {
        self.store = store
        viewModel = SignUpViewModel(state: store.eraseToObservable())
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
        smartView.emailTextField.addTarget(self, action: #selector(updateEmail(sender:)), for: .editingChanged)
        bind()
    }

    @objc private func signIn() {
        let email = smartView.emailTextField.text ?? ""
        store.emit(.signUp(email: email))
    }

    @objc private func updateEmail(sender textField: UITextField) {
        viewModel.email.emit(textField.text)
    }

    private func bind() {
        viewModel.isEnabled
            .bind(to: smartView.signUpButton.streams.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isInProgress
            .bind(to: smartView.activityIndicatorView.streams.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension SignUpViewController {
    fileprivate var smartView: SignUpView! {
        return view as? SignUpView
    }
}
