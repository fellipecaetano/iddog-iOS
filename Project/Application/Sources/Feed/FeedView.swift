import UIKit

final class FeedView: UIView {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: 500, height: 400)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FeedItemCollectionViewCell.self)
        return collectionView
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
        addSubview(collectionView)
    }

    private func createConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeTopAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeTrailingAnchor),
        ])
    }
}
