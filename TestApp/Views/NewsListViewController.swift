//
//  NewsListViewController.swift
//  TestApp
//
//  Created by Gourav on 07/06/25.
//

import UIKit

class NewsListViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private let viewModel = NewsViewModel()
    private var allNews: [NewsItem] = []
  

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchNews()
        setupTableView()
        setupActivityIndicator()
        bindViewModel()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        viewModel.fetchNews()
        refreshControl.endRefreshing()
    }

    private func bindViewModel() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showAlert(title: "Error", message: error)
                self?.viewModel.errorMessage = nil
            }
            .store(in: &viewModel.cancellable)
        viewModel.$businessNews
            .sink { [weak self] business in
                self?.allNews = business
                self?.tableView.reloadData()
            }
            .store(in: &viewModel.cancellable)
        viewModel.$isLoading
              .sink { [weak self] isLoading in
                  isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
              }
        .store(in: &viewModel.cancellable)
    }
}

//MARK: UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = allNews[indexPath.row]
        let webVC = WebViewController(urlString: newsItem.link)
        navigationController?.pushViewController(webVC, animated: true)
    }
}


//MARK: UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allNews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsItem = allNews[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: newsItem)
        return cell
    }
}



