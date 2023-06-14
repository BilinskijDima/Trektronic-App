//
//  Persistence.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
         return container.viewContext
     }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Trektronic-App")
        if inMemory {
            guard let containerFirst = container.persistentStoreDescriptions.first else {return}
            containerFirst.url = URL(filePath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
