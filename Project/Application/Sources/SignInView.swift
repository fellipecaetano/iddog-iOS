import UIKit

final class SignInView: UIView {
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = L10n.email
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none

        if #available(iOS 10.0, *) {
            textField.textContentType = .emailAddress
        }

        return textField
    }()

    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.signIn, for: [])
        return button
    }()

    init() {
        super.init(frame: UIScreen.main.bounds)
        setUp()
    }

    required init?(coder: NSCoder) {
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
        addSubview(signInButton)
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
        signInButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                signInButton.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
                signInButton.topAnchor.constraint(
                    equalTo: emailTextField.bottomAnchor, constant: layoutMargins.bottom * 3),
            ])
    }
}
