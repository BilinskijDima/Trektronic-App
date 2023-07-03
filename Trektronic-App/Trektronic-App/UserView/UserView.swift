//
//  UserView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 30.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserView: View {
    
    @StateObject var vm: UserViewModel
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                HStack {
                    WebImage(url: URL(string: vm.userSelf?.image ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                    VStack {
                        Text (vm.userSelf?.nickname ?? "")
                        Text ("\(vm.userSelf?.step ?? 0)")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text (vm.userFavorit?.nickname ?? "")
                        Text ("\(vm.userFavorit?.step ?? 0)")
                    }
                    WebImage(url: URL(string: vm.userFavorit?.image ?? ""))
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
                          
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .frame(width: vm.progressUserSelf, height: vm.height)
                                .foregroundColor(Color.purple)
                        }
              
                        ZStack(alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .frame(width: vm.width, height: vm.height)
                                .foregroundColor(Color.clear)
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .frame(width: vm.progressUserFavorit, height: vm.height)
                                .foregroundColor(Color.red)
                        }
                        HStack {
                            Divider()
                                .background(.blue)
                        }
                    }
                }
            }
           
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding([.horizontal, .top], 24)
        }
        .task {
            vm.fetchUser()
           
        }
        .navigationTitle (vm.user.nickname)
        .toolbar {
            Button(action: vm.updateUser, label: {
                Image(systemName: vm.isFavorite() ? "star.fill" : "star")
                    .foregroundColor( vm.isFavorite() ? Color.yellow : .baseColorWB)
            })

        }
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
}

