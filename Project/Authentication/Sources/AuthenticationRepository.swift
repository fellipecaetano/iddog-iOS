import Security

public struct AuthenticationRepository {
    public let get: () throws -> Authentication
    public let put: (Authentication) throws -> Void
    public let delete: () throws -> Void

    public static let live = AuthenticationRepository(
        get: {
            return Authentication(email: "", token: "")
        },
        put: { authentication in
        },
        delete: {
        }
    )
}
