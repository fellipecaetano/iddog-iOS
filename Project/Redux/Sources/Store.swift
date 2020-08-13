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

    public init(initialState: State, reducer: Reducer<State, Action, Environment>, environment: Environment) {
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

    public func scope<LocalState, LocalAction>(
        toLocalState: @escaping (State) -> LocalState,
        fromLocalAction: @escaping (LocalAction) -> Action
    ) -> AnyStore<LocalState, LocalAction> {
        return AnyStore(
            subscribe: { onComplete in
                return self.subscribe { state in
                    onComplete(toLocalState(state))
                }
            },
            emit: { action in
                self.emit(fromLocalAction(action))
            }
        )
    }
}

public struct AnyStore<State, Action>: Observable, Observer {
    private let _subscribe: (@escaping (State) -> Void) -> Disposable
    private let _emit: (Action) -> Void

    public init(subscribe: @escaping (@escaping (State) -> Void) -> Disposable, emit: @escaping (Action) -> Void) {
        _subscribe = subscribe
        _emit = emit
    }

    public func subscribe(_ handler: @escaping (State) -> Void) -> Disposable {
        return _subscribe(handler)
    }

    public func emit(_ value: Action) {
        _emit(value)
    }
}
