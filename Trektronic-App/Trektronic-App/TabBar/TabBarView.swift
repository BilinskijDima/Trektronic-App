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
        ZStack(alignment: .bottom) {
            
           Spacer()
            
            switch vm.selectedTab {
            case .house:
                HomeView()
            case .person:
                Text("3")
            case .gearshape:
                Text("4")
            case .message:
                Text("4")
         //       TestCoreDataView()
            case .folder:
                Text("5")
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
