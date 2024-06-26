//
//  FavoriteViewCell.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 4/14/24.
//

import UIKit

class FavoriteViewCell: UITableViewCell {
        
    private let bookImageView = UIImageView()
    private let bookAuthorLabel = UILabel()
    private let bookTitleLabel  = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    internal let networkManager: NetworkManagerProtocol = NetworkManager()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bookImageView)
        addSubview(activityIndicator)
        addSubview(bookAuthorLabel)
        addSubview(bookTitleLabel)
        
        configureBookImageView()
        configureActivityIndicator()
        configureBookAuthorLabel()
        configureBookTitleLabel()
        
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
        
        bookAuthorLabel.text = book.author
        bookTitleLabel.text = book.title
    }

    private func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.startAnimating()
    }

    private func configureBookImageView() {
        
    }
    
    private func configureBookAuthorLabel() {
        
    }

    private func configureBookTitleLabel() {
        
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
            bookTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
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

extension FavoriteViewCell {
    private func fetchBookImage(from url: String) {
        if let cacheImage = ImageCacheManager.shared.object(forKey: url as NSString) {
            bookImageView.image = cacheImage
            self.activityIndicator.stopAnimating()
            return
        }
        
        networkManager.fetchImage(from: url) { result in
            switch result {
            case .success(let bookImage):
                guard let extractedImage = UIImage(data: bookImage) else { return }
                self.bookImageView.image = extractedImage
                ImageCacheManager.shared.setObject(extractedImage, forKey: url as NSString)
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
