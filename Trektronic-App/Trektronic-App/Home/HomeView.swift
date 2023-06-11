//
//  HomeView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 9.06.23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: HomeViewModel = HomeViewModel()

    var body: some View {

        VStack {
            List(vm.steps, id: \.id) { step in
                VStack {
                    Text("\(step.count)")
                    Text(step.date, style: .date)
                        .opacity(0.5)
                }
            }
            .listStyle(.plain)
            .onAppear {
                vm.calculateData()
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


