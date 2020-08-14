import Alamofire
import Streams

public struct APIClient {
    public let signUp: (_ email: String) -> AnyObservable<Swift.Result<SignUpResponseJSON, APIError>>

    public let feed: (_ category: APIParameters.Category, _ token: String) -> AnyObservable<Swift.Result<FeedResponseJSON, APIError>>

    public static let live = APIClient(
        signUp: { email -> AnyObservable<Swift.Result<SignUpResponseJSON, APIError>> in
            HTTPClient.request(
                path: "signup",
                method: .post,
                parameters: ["email": email],
                encoding: JSONEncoding()
            )
        },
        feed: { category, token -> AnyObservable<Swift.Result<FeedResponseJSON, APIError>> in
            HTTPClient.request(
                path: "feed",
                method: .get,
                parameters: ["category": category.query],
                encoding: URLEncoding(),
                headers: ["Authorization": token]
            )
        }
    )
}
