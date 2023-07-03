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
                
        VStack(spacing: 0) {
            
            switch vm.selectedTab {
            case .house:
                HomeView()
            case .chart:
                StatisticsView(vm: vm.statisticsViewModel)
            case .person:
                PeopleView()
            case .gearshape:
                SettingsView()
            }
            
            Spacer()
            
            VStack {
                HStack {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Spacer()
                        Image(systemName: tab.rawValue)
                            .foregroundColor(tab == vm.selectedTab ? vm.selectedColor : tab.color)
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
        .task {
            vm.calculateDataHealthKitStep()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
