import Alamofire
import UIKit

class SignInViewController: UIViewController {
    override func loadView() {
        view = SignInView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        smartView.signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    @objc private func signIn() {
        let url = URL(string: "https://iddog-nrizncxqba-uc.a.run.app/signup")!

        request(
            url, method: .post, parameters: ["email": smartView.emailTextField.text ?? ""],
            encoding: JSONEncoding())
            .validate()
            .responseJSON
        { response in
            switch response.result {
            case let .success(data):
                print(data)
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
