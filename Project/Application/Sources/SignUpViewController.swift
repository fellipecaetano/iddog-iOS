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
    }

    @objc private func signIn() {
        APIClient.live.signUp(smartView.emailTextField.text ?? "")
            .subscribe { result in
                switch result {
                case let .success(response):
                    dump(response)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SignUpViewController {
    fileprivate var smartView: SignUpView! {
        return view as? SignUpView
    }
}
