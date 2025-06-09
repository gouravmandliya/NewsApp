//
//  NewsServiceTests.swift
//  TestAppTests
//
//  Created by Gourav on 09/06/25.
//

import XCTest
import Combine
@testable import TestApp

final class NewsServiceTests: XCTestCase {

    private var cancellable: Set<AnyCancellable> = []
       
       func testFetchNewsSuccess() {
           let mockHandler = MockNetworkHandler(response: NewsCategory(Business: [NewsItem(link: "Sample", og: "https://example.com", source: "Source", source_icon: "", title: "Sample")]))
           let service = NewsService(networkHandler: mockHandler)

           let expectation = XCTestExpectation(description: "Fetch news success")

           service.fetchNews()
               .sink(receiveCompletion: { completion in
                   if case .failure(let error) = completion {
                       XCTFail("Expected success but got error: \(error)")
                   }
               }, receiveValue: { category in
                   XCTAssertEqual(category.Business?.count, 1)
                   XCTAssertEqual(category.Business?.first?.title, "Sample")
                   expectation.fulfill()
               })
               .store(in: &cancellable)

           wait(for: [expectation], timeout: 2)
       }

       func testFetchNewsFailure() {
           let mockHandler = MockNetworkHandler(shouldFail: true)
           let service = NewsService(networkHandler: mockHandler)

           let expectation = XCTestExpectation(description: "Fetch news failure")

           service.fetchNews()
               .sink(receiveCompletion: { completion in
                   if case .failure = completion {
                       expectation.fulfill()
                   } else {
                       XCTFail("Expected failure but got success")
                   }
               }, receiveValue: { _ in })
               .store(in: &cancellable)

           wait(for: [expectation], timeout: 2)
       }
}
