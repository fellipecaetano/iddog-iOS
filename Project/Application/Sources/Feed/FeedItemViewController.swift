import UIKit

final class FeedItemViewController: UIViewController {
    private let imageURL: URL

    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = FeedItemView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        smartView.imageView.kf.setImage(with: imageURL)
    }
}

extension FeedItemViewController {
    var smartView: FeedItemView! {
        return view as? FeedItemView
    }
}
