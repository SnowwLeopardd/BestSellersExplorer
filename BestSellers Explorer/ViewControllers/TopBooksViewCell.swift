//
//  TopBestSellersViewCell.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/6/24.
//

import UIKit

class TopBooksViewCell: UICollectionViewCell {
    
     private let bookImage: UIImageView = {
       let image = UIImageView()
//        image.contentMode = .scaleAspectFill
//        image.tintColor = .white
//        image.clipsToBounds = true
        return image
    }()
    
    let bookAuthor: UILabel = {
        let bookAuthor = UILabel()
        bookAuthor.textAlignment = .left
        return bookAuthor
    }()
    
    let bookTitle: UILabel = {
        let bookTitle = UILabel()
        bookTitle.font = UIFont.boldSystemFont(ofSize: 14)
        bookTitle.textAlignment = .left
        return bookTitle
    }()
    
    let bookRank: UILabel = {
        let bookRank = UILabel()
        bookRank.font = UIFont.boldSystemFont(ofSize: 16)
        bookRank.textAlignment = .center
        return bookRank
    }()
    
    
    func configure(with book: Book) {
        fetchBookImage(from: book)
        setupBookImage()
        setupBookRank(book)
        setupBookTitle(book)
        setupBookAuthor(book)
        
        
    }
    
    // MARK: - Setup UI
    private func setupBookRank(_ book:Book) {
        self.bookRank.text = String("Rank № \(book.rank)")
        
        self.addSubview(bookRank)
        bookRank.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookRank.topAnchor.constraint(equalTo: self.topAnchor),
            bookRank.bottomAnchor.constraint(equalTo: bookImage.topAnchor),
            bookRank.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookRank.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupBookImage() {
//        backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        backgroundColor = .white

        self.addSubview(bookImage)
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            bookImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,  constant: -40),
            bookImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupBookTitle(_ book: Book) {
        self.bookTitle.text = book.title
        
        self.addSubview(bookTitle)
        bookTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookTitle.topAnchor.constraint(equalTo: bookImage.bottomAnchor),
            bookTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupBookAuthor(_ book: Book) {
        self.bookAuthor.text = book.author
        
        self.addSubview(bookAuthor)
        bookAuthor.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookAuthor.topAnchor.constraint(equalTo: bookTitle.bottomAnchor),
            bookAuthor.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bookAuthor.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bookAuthor.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImage.image = nil
    }
}

// MARK: - Networking
extension TopBooksViewCell {
    private func fetchBookImage(from book: Book) {
        
        if let cacheImage = ImageCacheManager.shared.object(forKey: book.bookImage as NSString) {
            bookImage.image = cacheImage
            return
        }
        
        NetworkManager.shared.fetchImage(from: book.bookImage) { [weak self] result in
            switch result {
            case .success(let bookImage):
                guard let bookImage = UIImage(data: bookImage) else { return }
                self?.bookImage.image = bookImage
                ImageCacheManager.shared.setObject(bookImage, forKey: book.bookImage as NSString)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
