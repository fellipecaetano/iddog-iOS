import UIKit

final class SignUpView: UIView {
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = L10n.email
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none

        if #available(iOS 10.0, *) {
            textField.textContentType = .emailAddress
        }

        return textField
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.signUp, for: [])
        return button
    }()

    init() {
        super.init(frame: UIScreen.main.bounds)
        setUp()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        configure()
        createHierarchy()
        createConstraints()
    }

    private func configure() {
        backgroundColor = .white
    }

    private func createHierarchy() {
        addSubview(emailTextField)
        addSubview(signUpButton)
    }

    private func createConstraints() {
        // emailTextField
        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                emailTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
                emailTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                emailTextField.trailingAnchor.constraint(
                    equalTo: layoutMarginsGuide.trailingAnchor),
            ])

        // signInButton
        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                signUpButton.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
                signUpButton.topAnchor.constraint(
                    equalTo: emailTextField.bottomAnchor, constant: layoutMargins.bottom * 3
                ),
            ])
    }
}
