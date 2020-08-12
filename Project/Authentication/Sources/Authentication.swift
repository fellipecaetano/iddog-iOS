public struct Authentication {
    public let email: String
    public let token: String
    
    public init (email: String, token: String) {
        self.email = email
        self.token = token
    }
}
