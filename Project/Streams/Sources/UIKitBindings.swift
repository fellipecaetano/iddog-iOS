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

extension NSObject: StreamsCompatible { }

extension Streams where Base: UIView {
    var isHidden: AnyObserver<Bool> {
        return AnyObserver { [base] value in
            base.isHidden = value
        }
    }
}

extension Streams where Base: UIButton {
    var isEnabled: AnyObserver<Bool> {
        return AnyObserver { [base] value in
            base.isEnabled = value
        }
    }
}
