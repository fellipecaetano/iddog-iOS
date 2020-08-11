import Streams

public final class Store<State: Equatable, Action>: Observable, Observer {
    public private(set) var state: State {
        didSet {
            if oldValue != state {
                subject.emit(state)
            }
        }
    }

    private let reducer: Reducer<State, Action>
    private let subject = Subject<State>()
    private var effectDisposables: [UUID: Disposable] = [:]

    init(initialState: State, reducer: Reducer<State, Action>) {
        state = initialState
        self.reducer = reducer
    }

    public func subscribe(_ handler: @escaping (State) -> Void) -> Disposable {
        handler(state)
        return subject.subscribe(handler)
    }

    public func emit(_ action: Action) {
        let effect = reducer.reduce(&state, action)
        let uuid = UUID()
        let disposable = effect.subscribe { action in
            self.emit(action)
            self.effectDisposables[uuid]?.dispose()
            self.effectDisposables[uuid] = nil
        }
        effectDisposables[uuid] = disposable
    }
}
