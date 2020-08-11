import Networking
import Streams
import UIKit

class SignInViewController: UIViewController {
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = SignInView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        smartView.signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    @objc private func signIn() {
        APIClient.live.signUp(smartView.emailTextField.text ?? "")
            .subscribe(
                { result in
                    switch result {
                    case let .success(response):
                        dump(response)
                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                })
            .disposed(by: disposeBag)
    }
}

extension SignInViewController {
    fileprivate var smartView: SignInView! {
        return view as? SignInView
    }
}
