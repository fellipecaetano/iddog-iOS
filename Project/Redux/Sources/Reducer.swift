import Streams

public struct Reducer<State, Action, Environment> {
    public let reduce: (inout State, Action, Environment) -> Effect<Action>

    public init(reduce: @escaping (inout State, Action, Environment) -> Effect<Action>) {
        self.reduce = reduce
    }
}
