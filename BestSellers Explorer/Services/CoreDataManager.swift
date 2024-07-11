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
    func create(_ book: Book) {
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
    
    func isUnique(_ primaryIsbn13: String) -> Bool {
        let fetchRequest = FavoriteBook.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "(primaryIsbn13 = %@)", primaryIsbn13)
        
        var similarbooks: [FavoriteBook] = []
            
        do {
            similarbooks = try mainContext.fetch(fetchRequest)
        } catch {
            print("Error fetching")
        }
        
        return similarbooks.isEmpty
    }
    
    func fetchBook(_ primaryIsbn13: String) -> FavoriteBook? {
        let fetchRequest = FavoriteBook.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "(primaryIsbn13 = %@)", primaryIsbn13)
        
        var similarbooks: [FavoriteBook] = []
            
        do {
            similarbooks = try mainContext.fetch(fetchRequest)
        } catch {
            print("Error fetching")
        }
        
        return similarbooks.first
    }
    
    func deleteFavoriteBook(by primaryIsbn13: String) {
        if let bookToDelete = fetchBook(primaryIsbn13) {
            delete(bookToDelete)
            NotificationCenter.default.post(name: .favoriteBooksUpdated, object: nil)
        } else {
            print("Book with ISBN \(primaryIsbn13) not found.")
        }
    }
}
