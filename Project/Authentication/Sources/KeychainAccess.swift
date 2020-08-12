import Security

public struct KeychainAccess {
    static func put(value: String, key: String) throws -> Void {
        guard let data = value.data(using: .utf8) else {
            throw KeychainAccessError.couldNotEncodeAsData(value: value)
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainAccessError.unhandledError(status: status)
        }
    }
}
