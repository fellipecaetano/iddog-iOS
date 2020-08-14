import Redux
import Streams
import UIKit

final class FeedViewController: UIViewController {
    private let store: AnyStore<FeedState, FeedAction>
    private let disposeBag = DisposeBag()
    private var imageURLs: [URL] = []

    init(store: AnyStore<FeedState, FeedAction>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
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
        smartView.segmentedControl.addTarget(self, action: #selector(reloadCategory(sender:)), for: .valueChanged)
        bind()
        store.emit(FeedAction.load(category: .hound))
    }

    private func bind() {
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

extension FeedViewController {
    fileprivate var smartView: FeedView! {
        return view as? FeedView
    }
}
