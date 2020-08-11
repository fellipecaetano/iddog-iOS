public struct FeedResponseJSON: Equatable, Decodable {
    public enum Category: String, Equatable, Decodable {
        case husky
        case hound
        case pug
        case labrador
    }

    public let category: Category
    public let list: [URL]
}
