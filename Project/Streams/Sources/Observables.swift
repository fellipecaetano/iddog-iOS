public enum Observables {
    public static func of<T>(_ values: T...) -> AnyObservable<T> {
        return AnyObservable { onComplete in
            for value in values {
                onComplete(value)
            }

            return Disposable.none
        }
    }

    public static func just<T>(_ value: T) -> AnyObservable<T> {
        return AnyObservable { onComplete in
            onComplete(value)
            return Disposable.none
        }
    }

    public static func merge<O: Observable>(_ observables: [O]) -> AnyObservable<O.SubscribedValue> {
        return AnyObservable { onComplete in
            let disposables = observables.map { observable in
                observable.subscribe(onComplete)
            }

            return Disposable {
                for disposable in disposables {
                    disposable.dispose()
                }
            }
        }
    }

    public static func empty<T>() -> AnyObservable<T> {
        return AnyObservable { _ in Disposable.none }
    }
}
