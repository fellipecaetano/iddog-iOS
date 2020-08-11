public enum APIError: Error {
    case couldNotDecodeResponse(Error)
    case requestFailed(Error)
}
