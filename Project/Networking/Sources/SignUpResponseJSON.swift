public struct SignUpResponseJSON: Equatable, Decodable {
    public struct User: Equatable, Decodable {
        public let email: String
        public let token: String
    }

    public let user: User
}
