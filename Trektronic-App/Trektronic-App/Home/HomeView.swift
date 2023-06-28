//
//  HomeView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 9.06.23.
//

import SwiftUI


struct CardsView: View {
    
    var name: String
    var nameValue: String
    var nameSettings: String
    var color: Color
    var data: String
    
    var body: some View {
        ZStack() {
            
            HStack() {
                
                VStack(alignment: .leading, spacing: 0){
                    
                    Text (name)
                        .opacity(0.5)
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                    
                    HStack(alignment: .lastTextBaseline) {
                        Text (data)
                            .bold()
                            .font(.system(size: 40))
                        Text (nameValue)
                            .bold()
                            .font(.system(size: 20))
                    }
                
                    Text (nameSettings)
                        .opacity(0.5)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                }
                .padding([.leading, .top], 24)
                
                Spacer()
                
                
            }
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(color)
        .cornerRadius(40)
        .padding(.bottom, 16)
        
    }
}

struct HomeView: View {
    
    @StateObject var vm: HomeViewModel = HomeViewModel()
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 0) {
                    CardsView(name: "STEP монета", nameValue: "STEP", nameSettings: "Множитель STEP: x1.0", color: .red, data: vm.stepsCoin.description)
                    
                    CardsView(name: "TRON монета", nameValue: "TROIN", nameSettings: "", color: .green, data: vm.user?.coin.description ?? "0")
                }
                .padding([.horizontal, .top], 24)
                
            }
            .navigationTitle("Домой")
            .toolbar {
                Button {
                    
                } label: { 
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.baseColorWB)
                }
            }
        }
        .task {
            vm.userData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


