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
    
    internal let bookName = UILabel()
    private let authorLabel = UILabel()
    private let bookDescription = UILabel()
    
    private let exploreAgain = UIButton()
    private let addTofavorites = UIButton()
    
    private let coreDataManager: CoreDataManagerProtocol = CoreDataManager()
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        fetchBookImage(from: book)
        setupBookImage()
        setupBookName()
        setupAuthorLabel()
        setupBookDescription()
        setupAddToFavoritesUI()
        setupExploreAgainUI()
    }
    
    // MARK: - SetupUI
    private func setupBookImage() {
        view.addSubview(bookImage)
        
        bookImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bookImage.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 400),
            bookImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupBookName() {
        bookName.text = book.title
        
        view.addSubview(bookName)
        
        bookName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookName.topAnchor.constraint(equalTo: bookImage.bottomAnchor),
            //            bookName.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            bookName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupAuthorLabel() {
        authorLabel.text = book.author
        
        view.addSubview(authorLabel)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: bookName.bottomAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupBookDescription() {
        let noDescription = "API doesn't provide description for books in this category"
        bookDescription.text = book.description.isEmpty ? noDescription : book.description
        bookDescription.numberOfLines = 10
        
        view.addSubview(bookDescription)
        
        bookDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookDescription.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            bookDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bookDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    private func setupAddToFavoritesUI() {
        addTofavorites.setTitle("Add to Favorites", for: .normal)
        addTofavorites.backgroundColor = UIColor.blue
        addTofavorites.setTitleColor(UIColor.white, for: .normal)
        addTofavorites.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addTofavorites.layer.cornerRadius = 10
        addTofavorites.addTarget(self, action: #selector(setupAddToFavoriesLogic), for: .touchUpInside)
        
        view.addSubview(addTofavorites)
        
        addTofavorites.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addTofavorites.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTofavorites.bottomAnchor.constraint(equalTo: bookDescription.bottomAnchor, constant: 100),
            addTofavorites.widthAnchor.constraint(equalToConstant: 200),
            addTofavorites.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupExploreAgainUI() {
        exploreAgain.setTitle("Explore again", for: .normal)
        exploreAgain.backgroundColor = UIColor.blue
        exploreAgain.setTitleColor(UIColor.white, for: .normal)
        exploreAgain.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        exploreAgain.layer.cornerRadius = 10
        exploreAgain.addTarget(self, action: #selector(setupExploreAgainLogic), for: .touchUpInside)
        
        view.addSubview(exploreAgain)
    
        exploreAgain.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exploreAgain.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exploreAgain.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            exploreAgain.widthAnchor.constraint(equalToConstant: 200),
            exploreAgain.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - ButtonsLogic
    @objc private func setupAddToFavoriesLogic() {
        let isUnique = coreDataManager.isUnique(book.primaryIsbn13)
        if isUnique {
            coreDataManager.create(book)
        } else {
            AlertController.showErrorAlert(on: self, 
                                           message: "This book has already been added to your favorites.")
        }
    }
    
    @objc func setupExploreAgainLogic() {
        navigationController?.pushViewController(CalendarVC(), animated: true)
    }
}
