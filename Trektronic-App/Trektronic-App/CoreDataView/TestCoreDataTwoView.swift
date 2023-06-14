//
//  TestCoreDataTwoView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import SwiftUI

struct TestCoreDataTwoView: View {
    // проверяем получение данных с базы на другую вью в реальном времени
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ItemTest.testData, ascending: true)], animation: .default)
    
    private var items: FetchedResults<ItemTest>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    Text(item.testData ?? "No data")
                }
            }
        }
    }
}

struct TestCoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        TestCoreDataTwoView()
    }
}
