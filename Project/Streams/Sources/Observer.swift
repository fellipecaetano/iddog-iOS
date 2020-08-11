public protocol Observer {
    associatedtype EmittedValue
    
    func emit(_ value: EmittedValue)
}

public extension Observer {
    func erase() -> AnyObserver<EmittedValue> {
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
