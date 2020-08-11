public final class Subject<T> {
    private var subscribers: [UUID: (T) -> Void] = [:]
    
    public func subscribe(_ handler: @escaping (T) -> Void) {
        let uuid = UUID()
        subscribers[uuid] = handler
    }
    
    public func emit(_ value: T) {
        for handler in subscribers.values {
            handler(value)
        }
    }
}
