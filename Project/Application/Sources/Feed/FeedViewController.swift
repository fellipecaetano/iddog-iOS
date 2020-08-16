import Redux
import Streams
import UIKit

final class FeedViewController: UIViewController {
    private let store: AnyStore<FeedState, FeedAction>
    private weak var delegate: FeedViewControllerDelegate?
    private let disposeBag = DisposeBag()
    private var imageURLs: [URL] = []

    init(store: AnyStore<FeedState, FeedAction>, delegate: FeedViewControllerDelegate?) {
        self.store = store
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: L10n.feed, image: Asset.feedTabBarIcon.image, selectedImage: Asset.feedTabBarIcon.image)
        title = L10n.feed
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = FeedView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        smartView.collectionView.dataSource = self
        smartView.collectionView.delegate = self
        bind()
        store.emit(FeedAction.load(category: .hound))
    }

    private func bind() {
        smartView.segmentedControl.addTarget(self, action: #selector(reloadCategory(sender:)), for: .valueChanged)

        store.subscribe { state in
            self.smartView.segmentedControl.selectedSegmentIndex = FeedCategory.allCases.firstIndex(of: state.category) ?? 0
            self.imageURLs = state.images
            self.smartView.collectionView.reloadData()
        }
        .disposed(by: disposeBag)

        store
            .map { $0.isLoading }
            .bind(to: smartView.activityIndicatorView.streams.isAnimating)
            .disposed(by: disposeBag)

        store
            .map { $0.isLoading }
            .bind(to: smartView.collectionView.streams.isHidden)
            .disposed(by: disposeBag)
    }

    @objc private func reloadCategory(sender segmentedControl: UISegmentedControl) {
        self.smartView.collectionView.contentOffset = .zero

        let selectedCategory = FeedCategory.allCases[segmentedControl.selectedSegmentIndex]
        store.emit(FeedAction.load(category: selectedCategory))
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FeedItemCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.render(imageURL: imageURLs[indexPath.item])
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.feedViewController(self, didSelectImage: imageURLs[indexPath.item])
    }
}

extension FeedViewController {
    fileprivate var smartView: FeedView! {
        return view as? FeedView
    }
}

protocol FeedViewControllerDelegate: AnyObject {
    func feedViewController(_ feedViewController: FeedViewController, didSelectImage imageURL: URL)
}
