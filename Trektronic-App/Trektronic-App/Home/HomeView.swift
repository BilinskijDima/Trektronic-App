//
//  HomeView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 9.06.23.
//

import SwiftUI

struct HomeView: View {
    var fireBaseManager: FirebaseManagerProtocol = FirebaseManager()
    @ObservedObject var vm: HomeViewModel = HomeViewModel()
    var body: some View {
        VStack{
            Button {
                //   fireBaseManager.setDataRealTime()
            }label: {
                Text (vm.text)
            }
        }
        .task {
            vm.ff()
        }
    }
        
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


