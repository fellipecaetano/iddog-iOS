public struct Reducer<State, Action> {
    let reduce: (inout State, Action) -> Void
}
