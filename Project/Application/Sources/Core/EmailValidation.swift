import Foundation

enum EmailValidation {
    enum Result: Equatable {
        case blank
        case invalid
        case valid
    }
    
    static func validate(email: String) -> Result {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty else {
            return .blank
        }

        if trimmedEmail.range(of: #"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"#, options: .regularExpression) != nil {
            return .valid
        } else {
            return .invalid
        }
    }
}
