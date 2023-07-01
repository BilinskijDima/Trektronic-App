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
    
    let user: Users?
    let userSelf: Users?
    var updateUser: () -> ()
    var isFavorite: () -> Bool
    
    var width: CGFloat = 300
    var height: CGFloat = 35
    
    var body: some View {
        
        let progressUserSelf = width * (CGFloat(userSelf?.step ?? 0)) / (CGFloat(userSelf?.step ?? 0) + CGFloat(vm.userFavorit?.step ?? 0))
        let progressUserFavorit = width * (CGFloat(vm.userFavorit?.step ?? 0)) / (CGFloat(userSelf?.step ?? 0) + CGFloat(vm.userFavorit?.step ?? 0))
        
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
                                .frame(width: width, height: height)
                                .foregroundColor(Color.black.opacity(0.1))
                          
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .frame(width: progressUserSelf, height: height)
                                .foregroundColor(Color.purple)
                        }
              
                        ZStack(alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .frame(width: width, height: height)
                                .foregroundColor(Color.clear)
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .frame(width: progressUserFavorit, height: height)
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
            vm.fetchUser(id: user?.id ?? "")
        }
        .navigationTitle (user?.nickname ?? "Name")
        .toolbar {
            Button(action: updateUser, label: {
                Image(systemName: isFavorite() ? "star.fill" : "star")
                    .foregroundColor( isFavorite() ? Color.yellow : .baseColorWB)
            })
            
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

