//
//  TopBestSellersViewCell.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/6/24.
//

import UIKit

class TopBooksViewCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let bookAuthorLabel = UILabel()
    private let bookTitleLabel = UILabel()
    private let bookRankLabel = UILabel()
    internal let bookImageView = UIImageView()
    internal var activityIndicator: UIActivityIndicatorView?
    
    internal let networkManager: NetworkManagerProtocol = NetworkManager()

    func configure(with book: Book) {
        activityIndicator = ActivityIndicator.start(in: bookImageView,
                                                    topAnchorConstant: (self.frame.height) / 2,
                                                    size: .large)
        fetchBookImage(from: book)
        
        self.addSubview(containerView)
        self.addSubview(bookRankLabel)
        self.addSubview(bookTitleLabel)
        self.addSubview(bookAuthorLabel)
        
        setupContainerView()
        setupBookImageView()
        setupBookRankLabel(with: book)
        setupBookTitleLabel(with: book)
        setupBookAuthorLabel(with: book)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
    }
    
    // MARK: - Setup constraints
    private func setupContainerView() {
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowRadius = 4
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        containerView.backgroundColor = .clear

        containerView.addSubview(bookImageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth / 3
        let itemHeight = itemWidth * 1.5
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.widthAnchor.constraint(equalToConstant: itemWidth),
            containerView.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
    }

    private func setupBookImageView() {
        bookImageView.layer.cornerRadius = 10
        bookImageView.layer.masksToBounds = true
        
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bookImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupBookRankLabel(with book: Book) {
        bookRankLabel.text = String("#\(book.rank)")
        bookRankLabel.font = UIFont.boldSystemFont(ofSize: 30)
        bookRankLabel.textAlignment = .left
        
        bookRankLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookRankLabel.topAnchor.constraint(equalTo: self.topAnchor),
            bookRankLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
            bookRankLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func setupBookTitleLabel(with book: Book) {
        bookTitleLabel.text = book.title
        bookTitleLabel.numberOfLines = 4
        bookTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        bookTitleLabel.textAlignment = .left
        
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookTitleLabel.topAnchor.constraint(equalTo: bookRankLabel.bottomAnchor),
            bookTitleLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
            bookTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupBookAuthorLabel(with book: Book) {
        bookAuthorLabel.text = book.author
        bookAuthorLabel.textAlignment = .left
        bookAuthorLabel.numberOfLines = 2
        
        bookAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
            bookAuthorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}


