import Streams

struct SignUpViewModel {
    private let state: AnyObservable<SignUpState>
    
    init (state: AnyObservable<SignUpState>) {
        self.state = state
    }
}
