//
//  NewsViewModel.swift
//  TestApp
//
//  Created by Gourav on 07/06/25.
//

import Combine

final class NewsViewModel: ObservableObject {
    
    @Published var businessNews: [NewsItem] = []
    
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private let service: NewsServiceProtocol
    var cancellable = Set<AnyCancellable>()

    init(service: NewsServiceProtocol = NewsService()) {
        self.service = service
    }

    func fetchNews() {
        isLoading = true
        service.fetchNews()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] category in
                self?.businessNews = category.Business ?? []
            })
            .store(in: &cancellable)
    }
}
