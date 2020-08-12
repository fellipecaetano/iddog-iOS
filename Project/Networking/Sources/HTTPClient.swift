import Alamofire
import Streams

enum HTTPClient {
    static func request<T: Decodable>(
        path: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding,
        headers: HTTPHeaders? = nil
    ) -> AnyObservable<Swift.Result<T, APIError>> {
        return AnyObservable { onComplete in
            let request = Alamofire.request(
                url(path: path),
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case let .success(data):
                    let decoder = JSONDecoder()

                    do {
                        let response = try decoder.decode(T.self, from: data)
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
    }

    private static func url(path: String) -> URLConvertible {
        return "https://iddog-nrizncxqba-uc.a.run.app/\(path)"
    }
}
