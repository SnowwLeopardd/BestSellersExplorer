//
//  TopBestSellersViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/8/24.
//

import UIKit

class TopBooksVC: UIViewController {
    
    private var sortedBooks: [Book]!
    private let sortButton = UIBarButtonItem()
    
    // MARK: - UI Components
   private var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: 190, height: 400)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TopBooksViewCell.self, forCellWithReuseIdentifier: "TopBestSellersViewCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        fetchTopBestSellers()
        setupSortButton()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupSortButton() {
        sortButton.title = "Sort By: ↑"
        sortButton.style = .plain
        sortButton.target = self
        sortButton.action = #selector(sortButtonPressed)
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    @objc func sortButtonPressed() {
        let isAscending = sortButton.title == "Sort By: ↓"
        sortedBooks.sort { isAscending ? $0.rank < $1.rank : $0.rank > $1.rank }
        sortButton.title = isAscending ? "Sort By: ↑": "Sort By: ↓"
        collectionView.reloadData()
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension TopBooksVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopBestSellersViewCell", for: indexPath) as? TopBooksViewCell else { return UICollectionViewCell() }
        
        let book = sortedBooks[indexPath.row]
        cell.configure(with: book)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = sortedBooks[indexPath.row]
        
        let bookInfoVC = BookInfoVC()
        bookInfoVC.book = book
        
        navigationController?.pushViewController(bookInfoVC, animated: true)
        
    }
}

// FIXME: - add NSCacheManager
// MARK: - FetchData
extension TopBooksVC {
    private func fetchTopBestSellers() {
        let url = Link.TopBooksList.rawValue + UserDefaultsManager.shared.retrieveDate() + "/" + UserDefaultsManager().retrieveSelectedCategory() + Link.NYTimesApiKey.rawValue
        
        NetworkManager.shared.fetch(TopBooksList.self, from: url) { [weak self] result in
            switch result {
            case .success(let bestSellersList):
                let sortedBooks = bestSellersList.results.books.sorted { $0.rank < $1.rank }
                self?.sortedBooks = sortedBooks
                    DispatchQueue.main.async {
                        self?.setupCollectionView()
                    }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

