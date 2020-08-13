public protocol Observable {
    associatedtype SubscribedValue

    func subscribe(_ handler: @escaping (SubscribedValue) -> Void) -> Disposable
}

extension Observable {
    public func map<T>(_ fn: @escaping (SubscribedValue) -> T) -> AnyObservable<T> {
        return AnyObservable { onComplete in
            self.subscribe { value in
                onComplete(fn(value))
            }
        }
    }

    public func eraseToObservable() -> AnyObservable<SubscribedValue> {
        return AnyObservable(subscribe)
    }
}

public struct AnyObservable<T>: Observable {
    private let _subscribe: (@escaping (T) -> Void) -> Disposable

    public init(_ subscribe: @escaping (@escaping (T) -> Void) -> Disposable) {
        _subscribe = subscribe
    }

    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposable {
        return _subscribe(handler)
    }
}
