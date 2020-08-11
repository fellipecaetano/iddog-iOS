import Alamofire
import Streams

public struct APIClient {
    public let signUp:
        (_ email: String) -> AnyObservable<Swift.Result<SignUpResponseJSON, APIError>>

    public let feed:
        (_ category: APIParameters.Category) -> AnyObservable<
            Swift.Result<FeedResponseJSON, APIError>
        >

    public static let live = APIClient(
        signUp: { email -> AnyObservable<Swift.Result<SignUpResponseJSON, APIError>> in
            return AnyObservable<Swift.Result<SignUpResponseJSON, APIError>> { onComplete in
                let request = Alamofire.request(
                    "https://iddog-nrizncxqba-uc.a.run.app/signup",
                    method: .post,
                    parameters: ["email": email],
                    encoding: JSONEncoding())
                    .validate()
                    .responseData
                { response in
                    switch response.result {
                    case let .success(data):
                        let decoder = JSONDecoder()

                        do {
                            let response = try decoder.decode(SignUpResponseJSON.self, from: data)
                            onComplete(.success(response))
                        } catch {
                            onComplete(.failure(.couldNotDecodeResponse(error)))
                        }
                    case let .failure(error):
                        onComplete(.failure(.requestFailed(error)))
                    }
                }

                return Disposable {
                    request.cancel()
                }
            }
        },
        feed: { category -> AnyObservable<Swift.Result<FeedResponseJSON, APIError>> in
            return AnyObservable<Swift.Result<FeedResponseJSON, APIError>> { onComplete in
                let request = Alamofire.request(
                    "https://iddog-nrizncxqba-uc.a.run.app/feed",
                    method: .get,
                    parameters: ["category": category.query],
                    encoding: URLEncoding())
                    .validate()
                    .responseData
                { response in
                    switch response.result {
                    case let .success(data):
                        let decoder = JSONDecoder()

                        do {
                            let response = try decoder.decode(FeedResponseJSON.self, from: data)
                            onComplete(.success(response))
                        } catch {
                            onComplete(.failure(.couldNotDecodeResponse(error)))
                        }
                    case let .failure(error):
                        onComplete(.failure(.requestFailed(error)))
                    }
                }

                return Disposable {
                    request.cancel()
                }
            }
        })
}
