//
//  AddTestCoreDataViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 17.06.23.
//

import Foundation
import CoreData

class AddTestCoreDataViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var total: String = ""
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save() {
        do {
            let test = Budget(context: context)
            test.titel = name
            test.total = Double(total) ?? 0
            try test.save()
        } catch {
            print (error.localizedDescription)
        }
        
    }
    
}
