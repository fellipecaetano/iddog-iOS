public protocol Observable {
    associatedtype SubscribedValue

    func subscribe(_ handler: @escaping (SubscribedValue) -> Void) -> Disposable
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
