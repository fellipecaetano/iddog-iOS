struct EmailValidation {
    enum Result: Equatable {
        case blank
        case invalid
        case valid
    }
    
    private let email: String
    
    init (email: String) {
        self.email = email
    }
    
    func validate() -> Result {
        return .valid
    }
}
