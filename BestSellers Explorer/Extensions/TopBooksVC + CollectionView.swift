//
//  TopBooksVC + CollectionView.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 6/12/24.
//
import UIKit

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
        
        let bookInfoVC = BookInfoVC(book: book)
        
        navigationController?.pushViewController(bookInfoVC, animated: true)
    }
}
