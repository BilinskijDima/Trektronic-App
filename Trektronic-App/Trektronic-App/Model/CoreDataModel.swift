//
//  CoreDataModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 17.06.23.
//

import Foundation
import CoreData

protocol CoreDataModel {
    static var viewContext: NSManagedObjectContext {get}
    func save() throws
    func delete() throws
}
extension CoreDataModel where Self: NSManagedObject {
    
    static var viewContext: NSManagedObjectContext {
        CoreDataManager.shared.persistentStoreContainer.viewContext
    }
    
    func save() throws {
        try Self.viewContext.save()
    }
    
    func delete() throws {
        Self.viewContext.delete(self)
        try save()
    }
    
    
}

struct TestViewModel: Identifiable {
    
    private var budget: Budget
    
    init(budget: Budget) {
        self.budget = budget
    }
    
    var id: NSManagedObjectID {
        budget.objectID
    }
    
    var titel: String {
        budget.titel ?? ""
    }
    
    var total: Double {
        budget.total
    }
    
}
