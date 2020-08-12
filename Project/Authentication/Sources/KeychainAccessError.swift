import Security

public enum KeychainAccessError: Error {
    case couldNotEncodeAsData(value: String)
    case unhandledError(status: OSStatus)
}
