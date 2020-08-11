import Streams

public struct APIClient {
    public let signUp: (_ email: String) -> AnyObservable<Result<SignUpResponseJSON, APIError>>
    public let feed:
        (_ category: APIParameters.Category) -> AnyObservable<Result<FeedResponseJSON, APIError>>

    public static let live = APIClient(
        signUp: { email -> AnyObservable<Result<SignUpResponseJSON, APIError>> in
            fatalError()
        },
        feed: { category -> AnyObservable<Result<SignUpResponseJSON, APIError>> in
            fatalError()
        })
}
