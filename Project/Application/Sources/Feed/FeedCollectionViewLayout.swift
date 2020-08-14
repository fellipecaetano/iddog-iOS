import UIKit

final class FeedCollectionViewLayout: UICollectionViewFlowLayout {
    init(spacing: CGFloat) {
        super.init()

        scrollDirection = .vertical
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }

    private let itemsPerRow = 3

    private var itemWidth: CGFloat {
        let availableWidth = UIScreen.main.bounds.width
            - CGFloat(itemsPerRow - 1) * minimumInteritemSpacing
            - sectionInset.left
            - sectionInset.right

        return floor(availableWidth / CGFloat(itemsPerRow))
    }

    private var itemHeight: CGFloat {
        return itemWidth * 0.8
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
