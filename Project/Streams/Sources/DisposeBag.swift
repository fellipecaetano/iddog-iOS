public final class DisposeBag {
    fileprivate var disposables = [Disposable]()
    
    deinit {
        for disposable in disposables {
            disposable.dispose()
        }
    }
}

public extension Disposable {
    func disposed(by bag: DisposeBag) {
        bag.disposables.append(self)
    }
}
