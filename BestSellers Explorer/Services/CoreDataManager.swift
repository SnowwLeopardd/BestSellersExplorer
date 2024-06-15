//
//  CoreDataManager.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 4/9/24.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    // MARK: - CoreData stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BestSellers_Explorer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    // MARK: - Core Data saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD operators
    func create(_ book: Book) {
        let favoriteBook = FavoriteBook(context: context)
        
        favoriteBook.title = book.title
        favoriteBook.author = book.author
        favoriteBook.about = book.description
        favoriteBook.amazonProductUrl = book.amazonProductUrl
        favoriteBook.primaryIsbn13 = book.primaryIsbn13
        favoriteBook.imageUrl = book.bookImage
        saveContext()
        NotificationCenter.default.post(name: .favoriteBooksUpdated, object: nil)
    }
    
    func fetchData(completion: (Result<[FavoriteBook], Error>) -> Void) {
        let fetchRequest = FavoriteBook.fetchRequest()
        
        do {
            let favoriteBooks = try context.fetch(fetchRequest)
            completion(.success(favoriteBooks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func delete(_ favoriteBook: FavoriteBook) {
        context.delete(favoriteBook)
        saveContext()
    }
    
    func isUnique(_ primaryIsbn13: String) -> Bool {
        let fetchRequest = FavoriteBook.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "(primaryIsbn13 = %@)", primaryIsbn13)
        
        var similarbooks: [FavoriteBook] = []
            
        do {
            similarbooks = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching")
        }
        
        return similarbooks.isEmpty
    }
}
