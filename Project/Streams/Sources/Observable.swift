public protocol Observable {
    associatedtype SubscribedValue

    func subscribe(_ handler: @escaping (SubscribedValue) -> Void) -> Disposable
}

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

public struct AnyObservable<T>: Observable {
    private let _subscribe: (@escaping (T) -> Void) -> Disposable

    public init(_ subscribe: @escaping (@escaping (T) -> Void) -> Disposable) {
        _subscribe = subscribe
    }

    public func subscribe(_ handler: @escaping (T) -> Void) -> Disposable {
        return _subscribe(handler)
    }
}
