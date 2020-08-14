import UIKit

final class FeedItemCollectionViewCell: UICollectionViewCell, Reusable {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        contentView.addSubview(imageView)
    }

    private func createConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func render(imageURL: URL) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: imageURL)

                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            } catch {
                print(error)
            }
        }
    }
}
