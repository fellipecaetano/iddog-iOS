extension Observable {
    public func bind<O: Observer>(to observer: O) -> Disposable where O.EmittedValue == SubscribedValue {
        return subscribe(observer.emit)
    }

    public func map<T>(_ fn: @escaping (SubscribedValue) -> T) -> AnyObservable<T> {
        return AnyObservable { onComplete in
            self.subscribe { value in
                onComplete(fn(value))
            }
        }
    }

    public func flatMap<T>(_ fn: @escaping (SubscribedValue) -> AnyObservable<T>) -> AnyObservable<T> {
        return AnyObservable { onComplete in
            var thisDisposable: Disposable?
            var transformedObservableDisposable: Disposable?

            thisDisposable = self.subscribe { value in
                transformedObservableDisposable = fn(value).subscribe(onComplete)
            }

            return Disposable {
                thisDisposable?.dispose()
                transformedObservableDisposable?.dispose()
            }
        }
    }

    public func eraseToObservable() -> AnyObservable<SubscribedValue> {
        return AnyObservable(subscribe)
    }
}

extension Observable where SubscribedValue: Equatable {
    public func distinctUntilChanged() -> AnyObservable<SubscribedValue> {
        return AnyObservable { onComplete in
            var lastValue: SubscribedValue?

            let disposable = self.subscribe { value in
                if value != lastValue {
                    onComplete(value)
                }

                lastValue = value
            }

            return disposable
        }
    }
}

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
