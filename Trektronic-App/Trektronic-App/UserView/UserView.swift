//
//  UserView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 30.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserView: View {
    
    @StateObject var vm: UserViewModel = UserViewModel()
    
    var userFavorit: Users?
    var userSelf: Users?
    var updateUser: () -> ()
    var isFavorite: () -> Bool
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                HStack {
                    WebImage(url: URL(string: userSelf?.image ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                    VStack {
                        Text (userSelf?.nickname ?? "")
                        Text ("\(userSelf?.step ?? 0)")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text (vm.userFavoritData?.nickname ?? "")
                        Text ("\(vm.userFavoritData?.step ?? 0)")
                    }
                    WebImage(url: URL(string: vm.userFavoritData?.image ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                }
                
                VStack{
                    ZStack(alignment: .center){
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .frame(width: vm.width, height: vm.height)
                                .foregroundColor(Color.black.opacity(0.1))
                          
                            Rectangle()
                                .cornerRadius(20, corners: [.bottomLeft, .topLeft])
                                .frame(width: vm.progressUserSelf, height: vm.height)
                                .foregroundColor(Color.purple)
                        }
              
                        ZStack(alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                
                                .frame(width: vm.width, height: vm.height)
                                .foregroundColor(Color.clear)
            
                            Rectangle()
                                .cornerRadius(20, corners: [.bottomRight, .topRight])
                                .frame(width: vm.progressUserFavorit, height: vm.height)
                                .foregroundColor(Color.red)
                        }
                     
                    }
                }
            }
           
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding([.horizontal, .top], 24)
        }
        .task {
            vm.fetchUser(id: userFavorit?.id ?? "", userSelfStep: userSelf?.step ?? 0)
           
        }
        .alert(item: $vm.alert) { value in
            return value.alert
        }
        .navigationTitle (userFavorit?.nickname ?? "")
        .toolbar {
            Button(action: updateUser, label: {
                Image(systemName: isFavorite() ? "star.fill" : "star")
                    .foregroundColor( isFavorite() ? Color.yellow : .baseColorWB)
            })

        }
        .navigationBarTitleDisplayMode(.inline)
       
    }
    
}

