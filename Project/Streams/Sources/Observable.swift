public protocol Observable {
    associatedtype SubscribedValue
    
    func subscribe(_ handler: @escaping (SubscribedValue) -> Void) -> Disposable
}

public extension Observable {
    func erase() -> AnyObservable<SubscribedValue> {
        return AnyObservable(subscribe)
    }
}

public struct AnyObservable<T>: Observable {
    private let _subscribe: (@escaping (T) -> Void) -> Disposable
    
    init (_ subscribe: @escaping (@escaping (T) -> Void) -> Disposable) {
        _subscribe = subscribe
    }
    
    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposable {
        return _subscribe(handler)
    }
}
