import Streams

public final class Store<State, Action>: Observable, Observer {
    public private(set) var state: State
    private let reducer: Reducer<State, Action>
    private let subject = Subject<State>()

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
        subject.emit(state)
        let disposable = effect.subscribe(emit)
        disposable.dispose()
    }
}
