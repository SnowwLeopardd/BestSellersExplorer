//
//  TopBestSellersViewCell.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/6/24.
//

import UIKit

class TopBooksViewCell: UICollectionViewCell {
    
     private let bookImageView = UIImageView()
     private var activityIndicator: UIActivityIndicatorView?
     private let bookAuthorLabel = UILabel()
     private let bookTitleLabel = UILabel()
     private let bookRankLabel = UILabel()
    
    func configure(with book: Book) {
        activityIndicator = ActivityIndicator.start(in: bookImageView, topAnchorConstant: (self.frame.height) / 2, size: .large)
        print(bookImageView.bounds.height)
        fetchBookImage(from: book)
        
        self.addSubview(bookRankLabel)
        self.addSubview(bookImageView)
        self.addSubview(bookTitleLabel)
        self.addSubview(bookAuthorLabel)
        
        setupBookImageConstrains()
        setupBookRankConstrains()
        setupBookTitleConstrains()
        setupBookAuthorConstrains()

        configureBookAuthorLabel(with: book)
        configureBookTitleLabel(with: book)
        configureBookRankLabel(with: book)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
    }
    
    // MARK: - Configure subViews
//    private func configureActivityIndicator() {
//        activityIndicator.style = .large
//        activityIndicator.startAnimating()
//    }
    
    private func configureBookImageView() {
        bookImageView.backgroundColor = .white
    }
    
    private func configureBookAuthorLabel(with book: Book) {
        bookAuthorLabel.text = book.author
        bookAuthorLabel.textAlignment = .left
    }
    
    private func configureBookTitleLabel(with book: Book) {
        bookTitleLabel.text = book.title
        bookTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        bookTitleLabel.textAlignment = .left
    }
    
    private func configureBookRankLabel(with book: Book) {
        bookRankLabel.text = String("Rank № \(book.rank)")
        bookRankLabel.font = UIFont.boldSystemFont(ofSize: 16)
        bookRankLabel.textAlignment = .center
    }
    
    // MARK: - Setup constrains
    private func setupBookRankConstrains() {
        bookRankLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookRankLabel.topAnchor.constraint(equalTo: self.topAnchor),
            bookRankLabel.bottomAnchor.constraint(equalTo: bookImageView.topAnchor),
            bookRankLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookRankLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupBookImageConstrains() {
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            bookImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,  constant: -40),
            bookImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupBookTitleConstrains() {
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookTitleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor),
            bookTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupBookAuthorConstrains() {
        bookAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor),
            bookAuthorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookAuthorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}

// MARK: - Networking
extension TopBooksViewCell {
    private func fetchBookImage(from book: Book) {
        if let cacheImage = ImageCacheManager.shared.object(forKey: book.bookImage as NSString) {
            bookImageView.image = cacheImage
            activityIndicator?.stopAnimating()
            return
        }
        
        NetworkManager.shared.fetchImage(from: book.bookImage) { [weak self] result in
            switch result {
            case .success(let bookImage):
                guard let bookImage = UIImage(data: bookImage) else { return }
                self?.bookImageView.image = bookImage
                ImageCacheManager.shared.setObject(bookImage, forKey: book.bookImage as NSString)
                self?.activityIndicator?.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
