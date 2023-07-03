//
//  HomeView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 9.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

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
        .cornerRadius(24)
        .padding(.bottom, 16)
        
    }
}

struct HomeView: View {
    
    @StateObject var vm: HomeViewModel = HomeViewModel()
    
    
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    VStack(alignment: .trailing) {
                        
                        HStack(alignment: .center) {

                            Spacer()
                            HStack(spacing: 0) {
                                Text(vm.user?.nickname ?? "")
                                    .font(.system(size: 25))
                                    .foregroundColor(.baseColorWB)
                                
                                Button {
                                    print ("переход в настройки")
                                } label: {
                                    WebImage(url: URL(string: vm.user?.image ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(25)
                                }
                                .padding(.leading, 8)
                            }
                            .padding(8)
                            .background(.blue)
                            .cornerRadius(24)
                            .padding(.bottom, 16)
                        }
                    }
                    
                    VStack(spacing: 0) {
                        CardsView(name: "STEP монета", nameValue: "STEP", nameSettings: "Множитель STEP: x1.0", color: .red, data: vm.stepsCoin.description)
                        
                        CardsView(name: "TRON монета", nameValue: "TROIN", nameSettings: "", color: .green, data: vm.user?.coin.description ?? "0")
                    }
                   
                    VStack {
                        Text("Избранные")
                            .bold()
                            .font(.system(size: 35))
                        .padding(.top, 24)
                        
                        ForEach(vm.users, id: \.hashValue) { user in
                            NavigationLink {
                                UserView(vm: UserViewModel(user: user, updateUser: { vm.updateFavorite(id: user.id) }, isFavorite: { vm.isFavorite(id: user.id) }))
                            } label: {
                                HStack(alignment: .center, spacing: 16) {
                                    
                            
                                        WebImage(url: URL(string: user.image))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(25)
                                 
                                    
                                    VStack {
                                        Text(user.nickname)
                                            .bold()
                                            .font(.system(size: 25))
                                            .foregroundColor(.baseColorWB)
                                    }
                                    Spacer()
                                    
                                    ZStack(alignment: .center) {
                                        
                                        Circle()
                                            .foregroundColor(.purple)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(25)
                                     
                                        Text("\(user.step)")
                                            .foregroundColor(.baseColorWB)
                                    }
                                }
                                
                            }
                            Divider()
                            
                        }
                
                        
                        
                        
                    }
               
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 24)
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
            vm.fetchFavoriteUser()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


