import UIKit

final class FeedView: UIView {
    private(set) lazy var collectionView: UICollectionView = {
        let layout = FeedCollectionViewLayout(spacing: layoutMargins.left * 2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(FeedItemCollectionViewCell.self)
        return collectionView
    }()

    let segmentedControl = UISegmentedControl(items: FeedCategory.allCases.map { $0.title })

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
        addSubview(segmentedControl)
        addSubview(collectionView)
    }

    private func createConstraints() {
        // segmentedControl
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeTopAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: layoutMargins.left * 2),
            segmentedControl.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -layoutMargins.right * 2)
        ])

        // collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: layoutMargins.top * 2),
            collectionView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeLeadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeTrailingAnchor),
        ])
    }
}
