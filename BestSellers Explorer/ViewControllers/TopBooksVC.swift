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
    private var activityIndicator: UIActivityIndicatorView?
    
    private var sortedBooks: [Book] = []
    private var selectedCategory: String
    private var selectedDate: String
    
    static let cellId = "TopBestSellersViewCell"
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
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
        collectionView.register(TopBooksViewCell.self, forCellWithReuseIdentifier: cellId )
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
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
        navigationController?.popToRootViewController(animated: true)
    }
}

extension TopBooksVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopBooksVC.cellId, for: indexPath) as? TopBooksViewCell else { return UICollectionViewCell() }
        
        let book = sortedBooks[indexPath.row]
        cell.configure(with: book)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = sortedBooks[indexPath.row]
        
        let bookInfoVC = BookInfoVC(book: book)
        
        navigationController?.pushViewController(bookInfoVC, animated: true)
    }
}

extension TopBooksVC {
    private func fetchTopBestSellers() {
        let topBooksURL = Link.topBooksList(date: selectedDate, category: selectedCategory).url
        
        networkManager.fetch(TopBooksList.self, from: topBooksURL) { [weak self] result in
            switch result {
            case .success(let bestSellersList):
                let sortedBooks = bestSellersList.results.books.sorted { $0.rank < $1.rank }
                self?.sortedBooks = sortedBooks
                DispatchQueue.main.async {
                    self?.setupCollectionView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .quotaLimitExceeded:
                        guard let self = self else { return }
                        AlertController.showErrorAlert(on: self,
                                                       title: String(localized: "Quota limit exceeded"),
                                                       message: String(localized: "NY Times API blocks too many inquiries. Please, wait 20 seconds"))
                    default:
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}


