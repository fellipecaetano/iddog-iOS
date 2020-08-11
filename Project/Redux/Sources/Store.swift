import Streams

final class Store<State, Action>: Observable, Observer {
    func subscribe(_ handler: @escaping (State) -> Void) -> Disposable {
        return Disposable {}
    }
    
    func emit(_ value: Action) {
    }
}
