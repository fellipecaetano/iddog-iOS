import Streams

public struct Effect<Value>: Observable {
    private let observable: AnyObservable<Value>

    public init<O: Observable>(observable: O) where O.SubscribedValue == Value {
        self.observable = observable.eraseToObservable()
    }

    public func subscribe(_ handler: @escaping (Value) -> Void) -> Disposable {
        return observable.subscribe(handler)
    }

    public static var empty: Effect {
        return Effect.run { _ in
            Disposable.none
        }
    }

    public static func run<T>(_ work: @escaping (@escaping (T) -> Void) -> Disposable) -> Effect<T> {
        let observable = AnyObservable<T>(work)
        return Effect<T>(observable: observable)
    }

    public static func fireAndForget<T>(_ work: @escaping (T) -> Void) -> Effect {
        return Effect.run { _ in
            return Disposable.none
        }
    }
}

public extension Observable {
    func eraseToEffect() -> Effect<SubscribedValue> {
        return Effect(observable: self)
    }
}
