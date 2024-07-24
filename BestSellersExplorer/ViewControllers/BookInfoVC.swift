//
//  BookInfo.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/25/24.
//

import UIKit

class BookInfoVC: UIViewController {
    
    private var book: Book
    
    private let bookImage = UIImageView()
    private let bookImageContainer = UIView()
    
    private let bookName = UILabel()
    private let authorLabel = UILabel()
    private let bookDescription = UILabel()
    
    private let addToFavorites = UIButton()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager()
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoriteBooksUpdated, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.9610984921, green: 0.9610984921, blue: 0.9610984921, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        
        fetchBookImage(from: book)
        
        setupScrollView()
        setupContentView()
        setupBookImageContainer()
        setupBookImageView()
        setupBookNameLabel()
        setupAuthorLabel()
        setupBookDescriptionLabel()
        
        setupAddToFavoritesButton()
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteBooksUpdated), name: .favoriteBooksUpdated, object: nil)
    }
    
    // MARK: - SetupUI
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupBookImageContainer() {
        bookImageContainer.layer.shadowColor = UIColor.black.cgColor
        bookImageContainer.layer.shadowOpacity = 0.5
        bookImageContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        bookImageContainer.layer.shadowRadius = 4
        bookImageContainer.layer.masksToBounds = false
        
        contentView.addSubview(bookImageContainer)
        
        bookImageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth / 1.5
        let itemHeight = itemWidth * 1.5
        
        NSLayoutConstraint.activate([
            bookImageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bookImageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bookImageContainer.widthAnchor.constraint(equalToConstant: itemWidth),
            bookImageContainer.heightAnchor.constraint(equalToConstant: itemHeight),
        ])
    }
    
    private func setupBookImageView() {
        bookImage.layer.cornerRadius = 10
        bookImage.clipsToBounds = true
        
        bookImageContainer.addSubview(bookImage)
        
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: bookImageContainer.topAnchor),
            bookImage.leadingAnchor.constraint(equalTo: bookImageContainer.leadingAnchor),
            bookImage.trailingAnchor.constraint(equalTo: bookImageContainer.trailingAnchor),
            bookImage.bottomAnchor.constraint(equalTo: bookImageContainer.bottomAnchor)
        ])
    }
    
    private func setupBookNameLabel() {
        bookName.text = book.title
        bookName.textAlignment = .center
        bookName.numberOfLines = 2
        bookName.font = UIFont.boldSystemFont(ofSize: 19)
        
        contentView.addSubview(bookName)
        
        bookName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookName.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 20),
            bookName.trailingAnchor.constraint(equalTo: bookImage.trailingAnchor),
            bookName.leadingAnchor.constraint(equalTo: bookImage.leadingAnchor)
        ])
    }
    
    private func setupAuthorLabel() {
        authorLabel.text = book.author
        authorLabel.textAlignment = .center
        authorLabel.numberOfLines = 2
        authorLabel.textColor = .gray
        
        contentView.addSubview(authorLabel)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: bookName.bottomAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: bookImage.trailingAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: bookImage.leadingAnchor)
        ])
    }
    
    private func setupBookDescriptionLabel() {
        let noDescription = String(localized: "BookInfoVC_noAPiDescription")
        bookDescription.text = book.description.isEmpty ? noDescription : book.description
        bookDescription.numberOfLines = 0
        bookDescription.textAlignment = .justified
        
        contentView.addSubview(bookDescription)
        
        bookDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookDescription.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            bookDescription.trailingAnchor.constraint(equalTo: bookImage.trailingAnchor),
            bookDescription.leadingAnchor.constraint(equalTo: bookImage.leadingAnchor)
        ])
    }
    
    private func setupAddToFavoritesButton() {
        addToFavorites.backgroundColor = UIColor.black
        addToFavorites.setTitleColor(UIColor.white, for: .normal)
        addToFavorites.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addToFavorites.layer.cornerRadius = 10
        addToFavorites.addTarget(self, action: #selector(handleAddToFavorites), for: .touchUpInside)
        updateAddToFavoritesButtonTitle()
        
        contentView.addSubview(addToFavorites)
        
        addToFavorites.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToFavorites.topAnchor.constraint(equalTo: bookDescription.bottomAnchor, constant: 16),
            addToFavorites.trailingAnchor.constraint(equalTo: bookImage.trailingAnchor),
            addToFavorites.leadingAnchor.constraint(equalTo: bookImage.leadingAnchor),
            addToFavorites.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func updateAddToFavoritesButtonTitle() {
        coreDataManager.isUnique(book.primaryIsbn13) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let isUnique):
                    let title = isUnique ? String(localized: "BookInfoVC_Add_to_Favorites") : String(localized: "BookInfoVC_Remove from Favorites")
                    self.addToFavorites.setTitle(title, for: .normal)
                case .failure(let error):
                    AlertController.showErrorAlert(on: self, message: "\(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func favoriteBooksUpdated() {
        DispatchQueue.main.async {
            self.updateAddToFavoritesButtonTitle()
        }
    }
    
    @objc private func handleAddToFavorites() {
        coreDataManager.isUnique(book.primaryIsbn13) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let isUnique):
                if isUnique {
                    self.coreDataManager.createFavoriteBook(from: self.book)
                } else {
                    self.coreDataManager.deleteFavoriteBook(by: self.book.primaryIsbn13) { result in
                        switch result {
                        case .success():
                            break
                        case .failure(let error):
                            DispatchQueue.main.async {
                                AlertController.showErrorAlert(on: self, message: "\(error)")
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.updateAddToFavoritesButtonTitle()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    AlertController.showErrorAlert(on: self, message: "\(error.localizedDescription)")
                }
            }
        }
    }
}

extension BookInfoVC {
    private func fetchBookImage(from book: Book) {
        let chacheImage = ImageCacheManager.shared.object(forKey: book.bookImage as NSString)
        bookImage.image = chacheImage
    }
}
