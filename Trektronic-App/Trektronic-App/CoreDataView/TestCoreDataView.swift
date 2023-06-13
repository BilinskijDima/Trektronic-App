//
//  TestCoreDataView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import SwiftUI

struct TestCoreDataView: View {
    // тестируем запись даных
    @State private var showingAlert = false
    @State private var name = ""
    @State private var number = 0
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ItemTest.testData, ascending: true)],
                  animation: .default)
    
    private var items: FetchedResults<ItemTest>
    
    var body: some View {
        VStack {
            
            TestCoreDataTwoView()
            Text("Две разные view на одной добавляем данные на вторую автоматически подтягиваются с базы даных")
                .padding(.horizontal, 24)
            NavigationView {
                List {
                    ForEach(items) { item in
                        Text(item.testData ?? "No data")
                    }
                }
                .navigationBarItems(trailing: Button(action: addItem, label: {
                    Image(systemName: "plus")
                }))
            }
        }
    }
    
    private func addItem() {
        self.number += 1 // для теста
        withAnimation {
            let newItem = ItemTest(context: viewContext)
            newItem.testData = "Hello \(number)"

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct TestCoreDataTwoView_Previews: PreviewProvider {
    static var previews: some View {
        TestCoreDataView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
