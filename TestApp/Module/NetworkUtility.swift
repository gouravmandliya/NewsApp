//
//  NetworkUtility.swift
//  TestApp
//
//  Created by Gourav on 09/06/25.
//

import Combine
import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol NetworkRequest {
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

public protocol NetworkHandlerProtocol {
    func request<T: Decodable>(_ request: NetworkRequest, responseType: T.Type) -> AnyPublisher<T, Error>
}

public final class NetworkHandler: NetworkHandlerProtocol {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<T: Decodable>(_ request: NetworkRequest, responseType: T.Type) -> AnyPublisher<T, Error> {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        request.headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                guard 200..<300 ~= response.statusCode else {
                    throw NSError(domain: "HTTPError", code: response.statusCode, userInfo: [
                        NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    ])
                }

                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
