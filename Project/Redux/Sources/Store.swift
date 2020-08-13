import Streams

public final class Store<State: Equatable, Action, Environment>: Observable, Observer {
    public private(set) var state: State {
        didSet {
            if oldValue != state {
                subject.emit(state)
            }
        }
    }

    private let reducer: Reducer<State, Action, Environment>
    private let environment: Environment
    private let subject = Subject<State>()
    private var effectDisposables: [UUID: Disposable] = [:]

    init(initialState: State, reducer: Reducer<State, Action, Environment>, environment: Environment) {
        state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    public func subscribe(_ handler: @escaping (State) -> Void) -> Disposable {
        handler(state)
        return subject.subscribe(handler)
    }

    public func emit(_ action: Action) {
        let effect = reducer.reduce(&state, action, environment)
        let uuid = UUID()
        let disposable = effect.subscribe { action in
            self.emit(action)
            self.effectDisposables[uuid]?.dispose()
            self.effectDisposables[uuid] = nil
        }
        effectDisposables[uuid] = disposable
    }
}
