//
//  TabBarView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject var vm: TabBarViewModel = TabBarViewModel()
    
    var body: some View {
        let viewContext = CoreDataManager.shared.persistentStoreContainer.viewContext
        
        VStack(spacing: 0) {
            
          // Spacer()
            
            switch vm.selectedTab {
            case .house:
                HomeView()
            case .chart:
                StatisticsView()
            case .person:
                TestCoreDataView(vm: TestCoreDataViewModel(context: viewContext))
                    .environment(\.managedObjectContext, viewContext)
            case .gearshape:
                Text("setting")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
            
            VStack {
                HStack {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Spacer()
                        Image(systemName: tab.rawValue)
                            .foregroundColor(tab == vm.selectedTab ? vm.selectedColor : tab.color) // не уверен что так
                            .font(.system(size: 25))
                            .onTapGesture {
                                    vm.selectedTab = tab
                            }
                            .padding(.vertical, 12)
                        Spacer()
                    }
                }
                .background(.thinMaterial)
                .cornerRadius(.greatestFiniteMagnitude)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
         
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
