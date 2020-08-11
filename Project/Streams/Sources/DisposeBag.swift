public final class DisposeBag {
    fileprivate var disposables = [Disposable]()

    public init() {}

    deinit {
        for disposable in disposables {
            disposable.dispose()
        }
    }
}

extension Disposable {
    public func disposed(by bag: DisposeBag) {
        bag.disposables.append(self)
    }
}
