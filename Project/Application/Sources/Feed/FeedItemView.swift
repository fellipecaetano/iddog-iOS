import UIKit

final class FeedItemView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
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
        backgroundColor = .black
    }
    
    private func createHierarchy() {
        addSubview(imageView)
    }
    
    private func createConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeAreaAnchors.leading),
            imageView.trailingAnchor.constraint(equalTo: safeAreaAnchors.trailing),
            imageView.topAnchor.constraint(equalTo: safeAreaAnchors.top),
            imageView.bottomAnchor.constraint(equalTo: safeAreaAnchors.bottom)
        ])
    }
}
