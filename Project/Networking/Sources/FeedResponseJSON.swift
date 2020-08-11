struct FeedResponseJSON: Equatable, Decodable {
    enum Category: String, Equatable, Decodable {
        case husky
        case hound
        case pug
        case labrador
    }

    let category: Category
    let list: [URL]
}
