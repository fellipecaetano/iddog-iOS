import Foundation
import Networking
import Redux
import Streams

let feedReducer = Reducer<AppState, FeedAction, FeedEnvironment> { state, action, environment in
    switch action {
    case let .load(category):
        state.feed.category = category

        guard let authentication = state.authentication.authentication else {
            return Effect.empty
        }

        return environment.apiClient.feed(category.parameter, authentication.token)
            .flatMap { result in
                switch result {
                case let .success(response):
                    return Observables.just(FeedAction.receive(images: response.list))
                case let .failure(error):
                    environment.log(error)
                    return Observables.empty()
                }
            }
            .eraseToEffect()
        
    case let .receive(images):
        state.feed.images = images
        return Effect.empty
    }
}

struct FeedState: Equatable {
    var category = FeedCategory.husky
    var images = [URL]()
}

enum FeedAction: Equatable {
    case load(category: FeedCategory)
    case receive(images: [URL])
}

struct FeedEnvironment {
    let apiClient: APIClient
    let log: (Any) -> Void
}
