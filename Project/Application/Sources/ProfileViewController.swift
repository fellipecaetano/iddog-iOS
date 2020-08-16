import UIKit

final class ProfileViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: L10n.profile, image: Asset.profileTabBarIcon.image, selectedImage: Asset.profileTabBarIcon.image)
        title = L10n.profile
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
    }
}
