import Security

struct KeychainAccess {
    enum Error: Swift.Error, Equatable {
        case couldNotEncodeAsData(value: String)
        case unhandledError(status: OSStatus)
        case noPassword
        case unexpectedPasswordData
    }

    struct Credentials: Equatable {
        let account: String
        let password: String
    }

    private let server: String

    init(server: String) {
        self.server = server
    }

    func put(credentials: Credentials) throws {
        guard let data = credentials.password.data(using: .utf8) else {
            throw Error.couldNotEncodeAsData(value: credentials.password)
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecAttrAccount as String: credentials.account,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
            kSecValueData as String: data,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw Error.unhandledError(status: status)
        }
    }

    func get() throws -> Credentials {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else {
            throw Error.noPassword
        }

        guard status == errSecSuccess else {
            throw Error.unhandledError(status: status)
        }

        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw Error.unexpectedPasswordData
        }

        return Credentials(account: account, password: password)
    }
    
    func delete() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw Error.unhandledError(status: status)
        }
    }
}
