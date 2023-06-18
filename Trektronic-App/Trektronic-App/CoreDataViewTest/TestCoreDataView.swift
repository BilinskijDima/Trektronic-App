//
//  TestCoreDataView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import SwiftUI

struct TestCoreDataView: View {
    
    @State private var isPresented: Bool = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject private var testCoreDataVM: TestCoreDataViewModel
    
    init(vm: TestCoreDataViewModel) {
        self.testCoreDataVM = vm
    }
    
    // тестируем запись даных
//    @State private var number = 0
//
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ItemTest.testData, ascending: true)],
//                  animation: .default)
//
//    private var items: FetchedResults<ItemTest>
    
    private func deleteBudget(at offsets: IndexSet) {

            offsets.forEach { index in
                let budget = testCoreDataVM.budgets[index]
                testCoreDataVM.deleteBudget(budgetId: budget.id)
            }
        
    }
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    ForEach(testCoreDataVM.budgets) { budget in
                        Text(budget.titel)
                    }.onDelete(perform: deleteBudget)
                }
            }
            .sheet(isPresented: $isPresented, content: {
                AddTestCoreDataView(vm: AddTestCoreDataViewModel(context: viewContext))
            })
            
            .navigationTitle("TestCoreData")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add New TestDataCore") {
                        isPresented = true
                    }
                }
            }

        }
        
        
//        VStack {
//
//            TestCoreDataTwoView()
//            Text("Две разные view на одной добавляем данные на вторую автоматически подтягиваются с базы даных")
//                .padding(.horizontal, 24)
//            NavigationView {
//                List {
//                    ForEach(items) { item in
//                        Text(item.testData ?? "No data")
//                    }
//                }
//                .navigationBarItems(trailing: Button(action: addItem, label: {
//                    Image(systemName: "plus")
//                }))
//            }
//        }
    }
    
//    private func addItem() {
//        self.number += 1 // для теста
//        withAnimation {
//            let newItem = ItemTest(context: viewContext)
//            newItem.testData = "Hello \(number)"
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

struct TestCoreDataTwoView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = CoreDataManager.shared.persistentStoreContainer.viewContext
        TestCoreDataView(vm: TestCoreDataViewModel(context: viewContext))
    }
}
