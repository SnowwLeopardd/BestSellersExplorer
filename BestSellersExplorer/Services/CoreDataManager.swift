//
//  CoreDataManager.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 4/9/24.
//

import CoreData

class CoreDataManager: CoreDataManagerProtocol {
    
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
    }
    
    // MARK: - Core Data saving support
    func saveContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD operators
    func createFavoriteBook(from book: Book) {
        let favoriteBook = FavoriteBook(context: mainContext)
        
        favoriteBook.rank = Int32(book.rank)
        favoriteBook.title = book.title
        favoriteBook.author = book.author
        favoriteBook.about = book.description
        favoriteBook.primaryIsbn13 = book.primaryIsbn13
        favoriteBook.imageUrl = book.bookImage
        saveContext()
        NotificationCenter.default.post(name: .favoriteBooksUpdated, object: nil)
    }
    
    func fetchData(completion: (Result<[FavoriteBook], Error>) -> Void) {
        let fetchRequest = FavoriteBook.fetchRequest()
        
        do {
            let favoriteBooks = try mainContext.fetch(fetchRequest)
            completion(.success(favoriteBooks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func delete(_ favoriteBook: FavoriteBook) {
        mainContext.delete(favoriteBook)
        saveContext()
    }
    
    func isUnique(_ primaryIsbn13: String, completion: (Result<Bool, Error>) -> Void) {
        let fetchRequest = FavoriteBook.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "(primaryIsbn13 = %@)", primaryIsbn13)
        
        do {
            let similarbooks = try mainContext.fetch(fetchRequest)
            let isEmpty = similarbooks.isEmpty
            completion(.success(isEmpty))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteFavoriteBook(by primaryIsbn13: String, completion: (Result<Void, Error>) -> Void) {
        let fetchRequest = FavoriteBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "primaryIsbn13 = %@", primaryIsbn13)
        
        var similarBooks: [FavoriteBook] = []
        
        do {
            similarBooks = try mainContext.fetch(fetchRequest)
        } catch let error {
            completion(.failure(error))
            return
        }
        
        if let bookToDelete = similarBooks.first {
            delete(bookToDelete)
            NotificationCenter.default.post(name: .favoriteBooksUpdated, object: nil)
            completion(.success(()))
        } else {
            let error = NSError(domain: "CoreData", code: 404, userInfo: [NSLocalizedDescriptionKey: String(localized: "Book with ISBN \(primaryIsbn13) not found.")])
            completion(.failure(error))
        }
    }
}
