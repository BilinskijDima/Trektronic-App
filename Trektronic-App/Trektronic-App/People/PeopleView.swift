//
//  PeopleView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 25.06.23.
//

import SwiftUI

struct PeopleView: View {
    
    @StateObject var vm: PeopleViewModel = PeopleViewModel()
    
    var body: some View {
        
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                ForEach(vm.users, id: \.hashValue) { user in
                    
                    HStack {
                        Text("Image")
                        VStack {
                            Text(user.nickname)
                            Text(user.date)
                        }
                        Spacer()
                        
                        Text("\(user.step)")
                        
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
            vm.fetchUser()
        }
        
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}
