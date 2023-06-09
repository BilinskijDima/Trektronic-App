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
        VStack {
            
           Spacer()
            
            switch vm.selectedTab {
            case .house:
                LoginView()
            case .person:
                OnboardingView()
            case .gearshape:
                Text("3")
            case .message:
                Text("4")
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
                        Spacer()
                    }
                }
                .frame(height: 60)
                .background(.thinMaterial)
                .cornerRadius(.greatestFiniteMagnitude)
                .padding()
            }
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
