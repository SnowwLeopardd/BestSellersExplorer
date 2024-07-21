//
//  MockCoreDataStack.swift
//  BestSellers ExplorerTests
//
//  Created by Aleksandr Bochkarev on 6/27/24.
//

import XCTest
import CoreData
@testable import BestSellersExplorer

class MockCoreDataStack {

    let persistentContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext

    init() {
        persistentContainer = NSPersistentContainer(name: "BestSellers_Explorer")
        mainContext = persistentContainer.viewContext
        let description = persistentContainer.persistentStoreDescriptions.first
        // create persistentContainer in memory
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
    }
}
