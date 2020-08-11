public protocol ObservableType {
    associatedtype Value
    
    func subscribe(_ handler: @escaping (Value) -> Void) -> Disposable
}

public extension ObservableType {
    func erase() -> AnyObservable<Value> {
        return AnyObservable(subscribe)
    }
}

public struct AnyObservable<T>: ObservableType {
    private let _subscribe: (@escaping (T) -> Void) -> Disposable
    
    init (_ subscribe: @escaping (@escaping (T) -> Void) -> Disposable) {
        _subscribe = subscribe
    }
    
    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposable {
        return _subscribe(handler)
    }
}
