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

        setupBookImageConstraints()
        setupActivityIndicatorConstraints()
        setupBookTitleConstraints()
        setupBookAuthorConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
        activityIndicator.startAnimating()
    }
    
    func configure(with book: FavoriteBook) {
        fetchBookImage(from: book.imageUrl ?? "No url")
        configureBookTitleLabel(with: book)
        configureBookAuthorLabel(with: book)
    }

    private func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
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

    private func setupBookImageConstraints() {
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            bookImageView.widthAnchor.constraint(equalToConstant: 80),
            bookImageView.heightAnchor.constraint(equalTo: bookImageView.widthAnchor)
        ])
    }
    
    private func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: bookImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: bookImageView.centerYAnchor)
        ])
    }
    
    private func setupBookTitleConstraints() {
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            bookTitleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 20),
            bookTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

    private func setupBookAuthorConstraints() {
        bookAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 10),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 20),
            bookAuthorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
