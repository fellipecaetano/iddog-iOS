import Redux
import Streams
import UIKit

final class FeedViewController: UIViewController {
    private let store: AnyStore<FeedState, FeedAction>
    private let disposeBag = DisposeBag()

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
        bind()
        store.emit(FeedAction.load(category: .pug))
    }

    private func bind() {
        store.subscribe { state in
            print(state)
        }
        .disposed(by: disposeBag)
    }
}

extension FeedViewController {
    fileprivate var smartView: FeedView! {
        return view as? FeedView
    }
}
