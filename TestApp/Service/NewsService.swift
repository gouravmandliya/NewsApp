//
//  NewsService.swift
//  TestApp
//
//  Created by Gourav on 09/06/25.
//

import Foundation
import Combine

public struct NewsAPIRequest: NetworkRequest {
    
    public let url: URL
    public let method: HTTPMethod = .post
    public let headers: [String: String]? = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    public let body: Data?

    public init(url: URL, sections: [String]) {
        self.url = url

        let payload = ["sections": sections]
        self.body = try? JSONSerialization.data(withJSONObject: payload, options: [])
    }
}

protocol NewsServiceProtocol {
    func fetchNews() -> AnyPublisher<NewsCategory, Error>
}

public final class NewsService: NewsServiceProtocol {
    private let networkHandler: NetworkHandlerProtocol
    private let endpoint = URL(string: "https://ok.surf/api/v1/news-section")!

    public init(networkHandler: NetworkHandlerProtocol = NetworkHandler()) {
        self.networkHandler = networkHandler
    }

    func fetchNews() -> AnyPublisher<NewsCategory, Error> {
        let request = NewsAPIRequest(url: endpoint, sections: ["Business"])
        return networkHandler.request(request, responseType: NewsCategory.self)
    }
}
