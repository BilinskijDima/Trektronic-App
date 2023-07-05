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
    }
}

struct TestCoreDataTwoView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = CoreDataManager.shared.persistentStoreContainer.viewContext
        TestCoreDataView(vm: TestCoreDataViewModel(context: viewContext))
    }
}
