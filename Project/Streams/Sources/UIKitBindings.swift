import UIKit

public struct Streams<Base> {
    fileprivate let base: Base
}

public protocol StreamsCompatible {
    associatedtype Base

    var streams: Streams<Base> { get }
}

extension StreamsCompatible {
    public var streams: Streams<Self> {
        return Streams(base: self)
    }
}

extension NSObject: StreamsCompatible {}

extension Streams where Base: UIView {
    public var isHidden: AnyObserver<Bool> {
        return AnyObserver { [base] value in
            base.isHidden = value
        }
    }
}

extension Streams where Base: UIButton {
    public var isEnabled: AnyObserver<Bool> {
        return AnyObserver { [base] value in
            base.isEnabled = value
        }
    }
}

extension Streams where Base: UILabel {
    public var text: AnyObserver<String?> {
        return AnyObserver { [base] value in
            base.text = value
        }
    }
}

extension Streams where Base: UIActivityIndicatorView {
    public var isAnimating: AnyObserver<Bool> {
        return AnyObserver { [base] value in
            if value {
                base.startAnimating()
            } else {
                base.stopAnimating()
            }
        }
    }
}
