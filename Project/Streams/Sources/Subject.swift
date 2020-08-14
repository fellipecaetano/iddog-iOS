public final class Subject<T>: Observable, Observer {
    private var subscribers: [UUID: (T) -> Void]

    public init() {
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

public final class SubjectWithInitialValue<T>: Observable, Observer {
    private var value: T
    private let subject = Subject<T>()

    public init(_ value: T) {
        self.value = value
    }

    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposable {
        handler(value)

        return subject.subscribe { value in
            self.value = value
            handler(value)
        }
    }

    public func emit(_ value: T) {
        subject.emit(value)
    }
}
