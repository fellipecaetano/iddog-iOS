final class TestObserver<T>: Observer {
    private(set) var values: [T] = []

    static func observing<O: Observable>(_ observable: O) -> TestObserver<O.SubscribedValue> {
        let observer = TestObserver<O.SubscribedValue>()
        _ = observable.bind(to: observer)
        return observer
    }

    func emit(_ value: T) {
        values.append(value)
    }
}
