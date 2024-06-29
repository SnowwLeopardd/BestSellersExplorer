//
//  FavoriteViewCell.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 4/14/24.
//

import UIKit

class FavoriteViewCell: UITableViewCell {
        
    private let bookAuthorLabel = UILabel()
    private let bookTitleLabel  = UILabel()
    internal let bookImageView = UIImageView()
    internal let activityIndicator = UIActivityIndicatorView()
    internal let networkManager: NetworkManagerProtocol = NetworkManager()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bookImageView)
        addSubview(activityIndicator)
        addSubview(bookAuthorLabel)
        addSubview(bookTitleLabel)
        
        configureBookImageView()
        configureActivityIndicator()
        configureBookImageView()

        setupBookImageConstrains()
        setupActivityIndicatorConstrains()
        setupBookTitleConstrains()
        setupBookAuthorConstrains()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
    }
    
    func configure(with book: FavoriteBook) {
        fetchBookImage(from: book.imageUrl ?? "No url")
        configureBookTitleLabel(with: book)
        configureBookAuthorLabel(with: book)

    }

    private func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.startAnimating()
    }

    private func configureBookImageView() {
        bookImageView.layer.cornerRadius = 10
        
        bookImageView.layer.shadowColor = UIColor.black.cgColor
        bookImageView.layer.shadowOpacity = 0.5
        bookImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bookImageView.layer.shadowRadius = 4
        
        bookImageView.layer.masksToBounds = false
    }
    
    private func configureBookAuthorLabel(with book: FavoriteBook) {
        bookAuthorLabel.text = book.author
        bookAuthorLabel.textAlignment = .left
    }

    private func configureBookTitleLabel(with book: FavoriteBook) {
        bookTitleLabel.text = book.title
        bookTitleLabel.numberOfLines = 2
        bookTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        bookTitleLabel.textAlignment = .left
    }

    private func setupBookImageConstrains() {
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bookImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bookImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            bookImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    private func setupActivityIndicatorConstrains() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: bookImageView.topAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: bookImageView.centerXAnchor)
        ])
    }
    
    private func setupBookTitleConstrains() {
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            bookTitleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 20),
            bookTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupBookAuthorConstrains() {
        bookAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 10),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 20),
            bookAuthorLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
