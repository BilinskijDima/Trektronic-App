//
//  TestCoreDataViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 17.06.23.
//

import Foundation
import CoreData

@MainActor
class TestCoreDataViewModel: NSObject, ObservableObject {
    
    @Published var budgets = [TestViewModel]()
    
    private let fetchedResultsController: NSFetchedResultsController<Budget>
    
    private (set) var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: Budget.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            
            guard let budgets = fetchedResultsController.fetchedObjects else {return}
            
            self.budgets = budgets.map(TestViewModel.init)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func deleteBudget(budgetId: NSManagedObjectID) {
        do {
            guard let budget = try context.existingObject(with: budgetId) as? Budget else {return}
            
            try budget.delete()
        } catch {
            print (error.localizedDescription)
        }
    }
    
    
}

extension TestCoreDataViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let budgets = controller.fetchedObjects as? [Budget] else {return}
        
        self.budgets = budgets.map(TestViewModel.init)
        
    }
}

