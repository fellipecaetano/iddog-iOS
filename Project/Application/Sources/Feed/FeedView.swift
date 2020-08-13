import UIKit

final class FeedView: UIView {
    init() {
        super.init(frame: UIScreen.main.bounds)
        setUp()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        backgroundColor = .cyan
    }
}
