//
//  CoreDataManager.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 17.06.23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentStoreContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    private init() {
        persistentStoreContainer = NSPersistentContainer(name: "Trektronic-App")
        persistentStoreContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialise Core Data \(error)")
            }
        }
    }
    
}
