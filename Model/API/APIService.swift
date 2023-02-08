import SwiftUI
import Combine

protocol APIServiceProtocol {
    func fetch<T: Decodable>(from url: URL) -> AnyPublisher<T, Error>
}

enum RequestError: Error {
    case addressUnreachable
    case invalidRequest
    case decodingError
    case timeOut
}

struct APIService: APIServiceProtocol {
    private func fetchURL(urlString: String) -> AnyPublisher<URL, Error> {
        Just(urlString)
            .tryMap {
                guard let url = URL(string: $0)
                else {
                    throw RequestError.addressUnreachable
                }
                return url
            }
            .eraseToAnyPublisher()
    }

    func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .catch {_ in
                return Fail(error: RequestError.invalidRequest)
            }
            .timeout(.seconds(5.0),
                     scheduler: DispatchQueue.main,
                     customError: {RequestError.timeOut})
            .eraseToAnyPublisher()
    }

    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error> {
        Just(data)
            .tryMap {data -> T in
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw RequestError.decodingError
                }
            }
            .map {$0}
            .eraseToAnyPublisher()
    }

    func fetch<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        Just(url)
            .flatMap(fetchData)
            .flatMap(decode)
            .eraseToAnyPublisher()
    }
}
