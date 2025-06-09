//
//  NewsItem.swift
//  TestApp
//
//  Created by Gourav on 07/06/25.
//

import Foundation

struct NewsItem: Codable, Identifiable {
    var id: String { link }
    let link: String
    let og: String
    let source: String
    let source_icon: String
    let title: String
}
