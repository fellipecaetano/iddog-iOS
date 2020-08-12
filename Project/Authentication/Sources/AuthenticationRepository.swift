private let keychain = KeychainAccess(server: "iddog-nrizncxqba-uc.a.run.app")

public struct AuthenticationRepository {
    public enum Error: Swift.Error {
        case notAuthenticated
        case unhandledError(Swift.Error)
    }

    public let get: () throws -> Authentication
    public let put: (Authentication) throws -> Void

    public static let live = AuthenticationRepository(
        get: {
            do {
                let credentials = try keychain.get()
                return Authentication(email: credentials.account, token: credentials.password)
            } catch {
                switch error {
                case KeychainAccess.Error.noPassword:
                    throw Error.notAuthenticated
                default:
                    throw Error.unhandledError(error)
                }
            }
        },
        put: { authentication in
            let credentials = KeychainAccess.Credentials(account: authentication.email, password: authentication.token)

            do {
                try keychain.put(credentials: credentials)
            } catch {
                throw Error.unhandledError(error)
            }
        }
    )
}
