//
//  ItemTest + Extension.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 17.06.23.
//

import Foundation
import CoreData

extension Budget: CoreDataModel {
    static var all: NSFetchRequest<Budget> {
        let request = Budget.fetchRequest()
        request.sortDescriptors = []
        return request
    }
}
