import UIKit
import Kingfisher

final class FeedItemCollectionViewCell: UICollectionViewCell, Reusable {
    private var imageDownloadTask: RetrieveImageTask?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        backgroundColor = .black
    }

    private func createHierarchy() {
        addSubview(imageView)
    }

    private func createConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    override func prepareForReuse() {
        imageDownloadTask?.cancel()
        imageView.image = nil
    }

    func render(imageURL: URL) {
        imageDownloadTask = imageView.kf.setImage(with: imageURL)
    }
}
