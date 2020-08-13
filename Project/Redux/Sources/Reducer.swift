import Streams

public struct Reducer<State, Action, Environment> {
    public let reduce: (inout State, Action, Environment) -> Effect<Action>

    public init(reduce: @escaping (inout State, Action, Environment) -> Effect<Action>) {
        self.reduce = reduce
    }

    public func pullback<GlobalState, GlobalAction, GlobalEnvironment>(
        state toLocalState: WritableKeyPath<GlobalState, State>,
        toAction toLocalAction: @escaping (GlobalAction) -> Action?,
        fromAction fromLocalAction: @escaping (Action) -> GlobalAction,
        environment toLocalEnvironment: @escaping (GlobalEnvironment) -> Environment
    ) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment> {
        return Reducer<GlobalState, GlobalAction, GlobalEnvironment> { globalState, globalAction, globalEnvironment in
            guard let localAction = toLocalAction(globalAction) else {
                return Effect.empty
            }

            return self.reduce(
                &globalState[keyPath: toLocalState],
                localAction,
                toLocalEnvironment(globalEnvironment)
            )
            .map(fromLocalAction)
            .eraseToEffect()
        }
    }

    public static func combine(_ reducers: Reducer...) -> Reducer {
        return Self { state, action, environment in
            let effects: [Effect<Action>] = reducers.map { $0.reduce(&state, action, environment) }

            return AnyObservable<Action> { onComplete in
                let disposables = effects.map { effect in
                    effect.subscribe(onComplete)
                }

                return Disposable {
                    for disposable in disposables {
                        disposable.dispose()
                    }
                }
            }
            .eraseToEffect()
        }
    }
}
