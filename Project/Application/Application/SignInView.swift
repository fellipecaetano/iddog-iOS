import UIKit

final class SignInView: UIView {
    init() {
        super.init(frame: UIScreen.main.bounds)
        setUp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .gray
    }
}
