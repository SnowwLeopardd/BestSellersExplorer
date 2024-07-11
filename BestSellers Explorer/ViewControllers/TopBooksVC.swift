//
//  TopBestSellersViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 2/8/24.
//

import UIKit

class TopBooksVC: UIViewController {
    
    private let sortButton = UIBarButtonItem()
    private let resetButton = UIBarButtonItem()
    internal var sortedBooks: [Book] = []
    internal var selectedCategory: String
    internal var selectedDate: String
    internal var activityIndicator: UIActivityIndicatorView?
    internal let networkManager: NetworkManagerProtocol = NetworkManager()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 40 
        let itemHeight = itemWidth / 1.77
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
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
        view.backgroundColor = .white
        activityIndicator = ActivityIndicator.start(in: self.view,
                                                    topAnchorConstant: 400,
                                                    size: .large)
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.hidesBackButton = true
        
        fetchTopBestSellers()
        setupSortButton()
        setupResetButton()
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
        sortButton.title = String(localized: "Sort By: ↑")
        sortButton.style = .plain
        sortButton.target = self
        sortButton.action = #selector(sortButtonPressed)
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    @objc func sortButtonPressed() {
        let isAscending = sortButton.title == String(localized: "Sort By: ↓")
        sortedBooks.sort { isAscending ? $0.rank < $1.rank : $0.rank > $1.rank }
        sortButton.title = isAscending ? String(localized: "Sort By: ↑") : String(localized: "Sort By: ↓")
        collectionView.reloadData()
    }
    
    private func setupResetButton() {
        resetButton.title = String(localized: "Reset")
        resetButton.style = .plain
        resetButton.target = self
        resetButton.action = #selector(resetButtonPressed)
        
        navigationItem.leftBarButtonItem = resetButton
    }
    
    @objc func resetButtonPressed() {
        navigationController?.pushViewController(CalendarVC(), animated: true)
    }
}




