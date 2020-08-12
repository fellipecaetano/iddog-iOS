import Networking
import Streams
import UIKit
import Authentication

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
        APIClient.live.signUp(smartView.emailTextField.text ?? "")
            .subscribe { result in
                switch result {
                case let .success(response):
                    let authentication = Authentication(email: response.user.email, token: response.user.token)
                    
                    do {
                        try AuthenticationRepository.live.put(authentication)
                    } catch {
                        print(error)
                    }
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
