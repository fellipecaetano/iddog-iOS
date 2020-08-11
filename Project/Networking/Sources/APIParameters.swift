public enum APIParameters {
    public enum Category: String {
        case husky
        case hound
        case pug
        case labrador

        var query: String {
            return rawValue
        }
    }
}
