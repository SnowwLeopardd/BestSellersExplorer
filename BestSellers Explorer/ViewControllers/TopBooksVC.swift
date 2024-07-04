//
//  TopBestSellersViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/8/24.
//

import UIKit

class TopBooksVC: UIViewController {
    
    private let sortButton = UIBarButtonItem()
    internal var sortedBooks: [Book] = []
    internal var selectedCategory: String
    internal var selectedDate: String
    internal let networkManager: NetworkManagerProtocol = NetworkManager()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.minimumLineSpacing = 17
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TopBooksViewCell.self, forCellWithReuseIdentifier: "TopBestSellersViewCell")
        return collectionView
    }()
    
    init(selectedCategory: String, selectedDate: String) {
        self.selectedCategory = selectedCategory
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.hidesBackButton = true
        fetchTopBestSellers()
        setupSortButton()
    }
    
    internal func setupCollectionView() {
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




