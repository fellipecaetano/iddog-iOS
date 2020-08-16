import UIKit

final class ProfileView: UIView {
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.signOut, for: [])
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
        createHierarchy()
        createConstraints()
    }

    private func createHierarchy() {
        addSubview(emailLabel)
        addSubview(signOutButton)
    }

    private func createConstraints() {
        // emailLabel
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emailLabel.centerYAnchor.constraint(equalTo: safeAreaAnchors.centerY),
            emailLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])

        // signOutButton
        signOutButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: emailLabel.centerXAnchor),
            signOutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: layoutMargins.bottom * 3),
        ])
    }
}
