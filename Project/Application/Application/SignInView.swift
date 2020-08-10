import UIKit

final class SignInView: UIView {
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        
        if #available(iOS 10.0, *) {
            textField.textContentType = .emailAddress
        }
        
        return textField
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
    }
    
    private func createConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        ])
    }
}
