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
        bind()
        store.emit(FeedAction.load(category: .hound))
    }

    private func bind() {
        store.subscribe { state in
            self.imageURLs = state.images
            self.smartView.collectionView.reloadData()
        }
        .disposed(by: disposeBag)
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
