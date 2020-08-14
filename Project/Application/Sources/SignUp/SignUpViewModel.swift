import Streams

struct SignUpViewModel {
    private let state: AnyObservable<SignUpState>

    init(state: AnyObservable<SignUpState>) {
        self.state = state
    }

    let email = SubjectWithInitialValue<String?>(nil)

    var isEnabled: AnyObservable<Bool> {
        return email
            .map(EmailValidation.validate(email:))
            .map { $0 == .valid }
    }
}
