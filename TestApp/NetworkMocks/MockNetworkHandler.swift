//
//  MockNetworkHandler.swift
//  TestApp
//
//  Created by Gourav on 09/06/25.
//

import Combine
import Foundation

final class MockNetworkHandler: NetworkHandlerProtocol {
    private let response: NewsCategory?
    private let shouldFail: Bool

    init(response: NewsCategory? = nil, shouldFail: Bool = false) {
        self.response = response
        self.shouldFail = shouldFail
    }

    func request<T>(_ request: NetworkRequest, responseType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        if shouldFail {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }

        guard let response = response as? T else {
            return Fail(error: URLError(.cannotDecodeRawData)).eraseToAnyPublisher()
        }

        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
