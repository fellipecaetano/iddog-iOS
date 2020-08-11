public final class Subject<T>: Observable, Observer {
    private var subscribers: [UUID: (T) -> Void]
    
    public init () {
        subscribers = [:]
    }
    
    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposable {
        let uuid = UUID()
        subscribers[uuid] = handler
        
        return Disposable { [weak self] in
            self?.subscribers[uuid] = nil
        }
    }
    
    public func emit(_ value: T) {
        for handler in subscribers.values {
            handler(value)
        }
    }
}
