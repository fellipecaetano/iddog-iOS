import UIKit

extension UIView {
    var safeAreaAnchors: SafeAreaLayoutAnchors {
        if #available(iOS 11.0, *) {
            return SafeAreaLayoutAnchors(
                top: safeAreaLayoutGuide.topAnchor,
                bottom: safeAreaLayoutGuide.bottomAnchor,
                centerY: safeAreaLayoutGuide.centerYAnchor,
                leading: safeAreaLayoutGuide.leadingAnchor,
                trailing: safeAreaLayoutGuide.trailingAnchor,
                centerX: safeAreaLayoutGuide.centerXAnchor
            )
        } else {
            return SafeAreaLayoutAnchors(
                top: topAnchor,
                bottom: bottomAnchor,
                centerY: centerYAnchor,
                leading: leadingAnchor,
                trailing: trailingAnchor,
                centerX: centerXAnchor
            )
        }
    }
}

struct SafeAreaLayoutAnchors {
    let top: NSLayoutYAxisAnchor
    let bottom: NSLayoutYAxisAnchor
    let centerY: NSLayoutYAxisAnchor
    let leading: NSLayoutXAxisAnchor
    let trailing: NSLayoutXAxisAnchor
    let centerX: NSLayoutXAxisAnchor
}
