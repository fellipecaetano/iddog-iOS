import UIKit
import Networking

class SignInViewController: UIViewController {
    override func loadView() {
        view = SignInView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        smartView.signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    @objc private func signIn() {
        _ = APIClient.live.signUp(smartView.emailTextField.text ?? "").subscribe { result in
            switch result {
            case let .success(response):
                dump(response)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SignInViewController {
    fileprivate var smartView: SignInView! {
        return view as? SignInView
    }
}
