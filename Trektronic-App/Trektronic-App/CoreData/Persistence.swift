//
//  Persistence.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController() //  это полноценная Core Data с хранением на диске

    static var preview: PersistenceController = {      // это фантомная Data для работы с превью
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<5 {
            let newItem = ItemTest(context: viewContext)
            newItem.testData = "фантомные данные"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Trektronic-App") // модель данных
        if inMemory {
            guard let containerFirst = container.persistentStoreDescriptions.first else {return}
            containerFirst.url = URL(filePath: "/dev/null") // /dev/null — специальный файл в системах класса UNIX, представляющий собой так называемое «пустое устройство» или “черную дыру”. Запись в него происходит успешно, независимо от объёма «записанной» информации.
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
