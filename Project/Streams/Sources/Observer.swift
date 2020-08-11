public protocol Observer {
    associatedtype Value
    
    func emit(_ value: Value)
}

public extension Observer {
    func erase() -> AnyObserver<Value> {
        return AnyObserver(emit)
    }
}

public struct AnyObserver<T>: Observer {
    private let _emit: (T) -> Void
    
    init (_ emit: @escaping (T) -> Void) {
        _emit = emit
    }
    
    public func emit(_ value: T) {
        _emit(value)
    }
}
