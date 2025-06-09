//
//  WebViewController.swift
//  TestApp
//
//  Created by Gourav on 07/06/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var webView: WKWebView!
    
    let urlString: String
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupActivityIndicator()
        loadRequest()
    }
    
    private func loadRequest() {
               DispatchQueue.main.async { [weak self] in
                   guard let self = self,
                         let url = URL(string: self.urlString) else { return }
                   let request = URLRequest(url: url)
                   self.activityIndicator.startAnimating()
                   self.webView.load(request)
               }
       }
    
    private func setupWebView() {
           webView = WKWebView()
           webView.navigationDelegate = self
           webView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(webView)
           
           NSLayoutConstraint.activate([
               webView.topAnchor.constraint(equalTo: view.topAnchor),
               webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
           ])
       }
       
       private func setupActivityIndicator() {
           activityIndicator.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(activityIndicator)
           
           NSLayoutConstraint.activate([
               activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           ])
       }
}

// MARK:- WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         activityIndicator.stopAnimating()
     }

     func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
         activityIndicator.stopAnimating()
         self.showAlert(title: "Failed to Load", message: error.localizedDescription)
     }

     func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
         activityIndicator.stopAnimating()
         self.showAlert(title: "Failed to Load", message: error.localizedDescription)
     }
}
