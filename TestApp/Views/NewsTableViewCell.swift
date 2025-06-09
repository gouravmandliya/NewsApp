//
//  NewsTableViewCell.swift
//  TestApp
//
//  Created by Gourav on 07/06/25.
//

import UIKit
import SDWebImage

final class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var sourceIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with news: NewsItem) {
        titleLabel.text = news.title
        sourceLabel.text = news.source
        thumbnailImageView.sd_setImage(with: URL(string: news.og))
        sourceIconImageView.sd_setImage(with: URL(string: news.source_icon))
    }

    private func setupViews() {
        [thumbnailImageView, titleLabel, sourceIconImageView, sourceLabel].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 100),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            sourceIconImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sourceIconImageView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            sourceIconImageView.widthAnchor.constraint(equalToConstant: 16),
            sourceIconImageView.heightAnchor.constraint(equalToConstant: 16),
            
            sourceLabel.centerYAnchor.constraint(equalTo: sourceIconImageView.centerYAnchor),
            sourceLabel.leadingAnchor.constraint(equalTo: sourceIconImageView.trailingAnchor, constant: 6),
            sourceLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}
