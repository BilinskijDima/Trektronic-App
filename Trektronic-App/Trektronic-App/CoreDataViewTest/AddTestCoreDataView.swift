//
//  AddTestCoreDataView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 17.06.23.
//

import SwiftUI

struct AddTestCoreDataView: View {
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var vm: AddTestCoreDataViewModel
    
    init(vm: AddTestCoreDataViewModel) {
        self.vm = vm
    }
    
    
    var body: some View {
        Form {
            TextField("Enter titel", text: $vm.name)
            TextField("Enter total", text: $vm.total)
            
            Button("Save") {
                
                vm.save()
                dismiss()
            }
            .navigationTitle("Add New TestCoreData")
        }
    }
}

struct AddAddTestCoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewContext = CoreDataManager.shared.persistentStoreContainer.viewContext
        NavigationView {
            AddTestCoreDataView(vm: AddTestCoreDataViewModel(context: viewContext))
        }
    }
}
