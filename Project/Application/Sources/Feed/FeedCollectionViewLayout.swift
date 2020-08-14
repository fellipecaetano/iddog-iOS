import UIKit

final class FeedCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()

        scrollDirection = .vertical
        minimumLineSpacing = 16
        minimumInteritemSpacing = 16
        sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }

    private let itemsPerRow = 3
    
    private var itemWidth: CGFloat {
        let availableWidth = UIScreen.main.bounds.width
            - CGFloat(itemsPerRow - 1) * minimumInteritemSpacing
            - sectionInset.left
            - sectionInset.right

        return floor(availableWidth/CGFloat(itemsPerRow))
    }
    
    private var itemHeight: CGFloat {
        return itemWidth * 0.8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}