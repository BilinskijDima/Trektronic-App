//
//  PeopleView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 25.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PeopleView: View {
    
    @StateObject var vm: PeopleViewModel = PeopleViewModel()
    
    @AppStorage("userID") var userID = DefaultSettings.userID

    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                ForEach(vm.users, id: \.hashValue) { user in
                    NavigationLink {
                        UserView(user: user, userSelf: vm.userSelf,
                                 updateUser: { vm.updateFavorite(id: user.id) },
                                 isFavorite: { vm.isFavorite(id: user.id) })
                        
                        // По поводу UserView , получается так, что на PeopleView я делаю обсервер запрос на список пользователей , то есть список автоматически будет изменяться в зависимости от новых пользователей , НО не их данные, поэтому на UserView я делаю еще один запрос на данные конкретного пользователя и поэтому они обновляются в реальном времени
                        
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
                .padding([.horizontal, .top], 24)
            }
            .navigationTitle("Люди")
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.baseColorWB)
                }
            }
        }
        .task {
            vm.fetchAllUsers()
            vm.fetchUser(id: userID)
        }
    }
    
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}
