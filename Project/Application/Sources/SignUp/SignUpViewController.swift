import Authentication
import Networking
import Streams
import UIKit

class SignUpViewController: UIViewController {
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = SignUpView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        smartView.signUpButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)

        do {
            let authentication = try AuthenticationRepository.live.get()
            smartView.emailTextField.text = authentication.email
        } catch {
            print(error)
        }
    }

    @objc private func signIn() {
        store.emit(.signUp(.signUp(email: smartView.emailTextField.text ?? "")))
    }
}

extension SignUpViewController {
    fileprivate var smartView: SignUpView! {
        return view as? SignUpView
    }
}
