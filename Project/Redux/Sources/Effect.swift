import Streams

public struct Effect<Value>: Observable {
    private let observable: AnyObservable<Value>

    init(observable: AnyObservable<Value>) {
        self.observable = observable
    }

    public func subscribe(_ handler: @escaping (Value) -> Void) -> Disposable {
        return observable.subscribe(handler)
    }

    public static func run<T>(_ work: @escaping (@escaping (T) -> Void) -> Disposable) -> Effect<T>
    {
        let observable = AnyObservable<T>(work)
        return Effect<T>(observable: observable)
    }

    public static var empty: Effect {
        return Effect.run { _ in
            Disposable.none
        }
    }
}
