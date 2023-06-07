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
        
        // Сделать все через enum 
        
        VStack(spacing: 0) {
            Spacer()
            
            Text("TabBar")
            
            Spacer()
            
            ZStack() {
        
                HStack {
                    
                    Button {
                        vm.tapButton = 0
                    } label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                          
                    }
                    .foregroundColor(vm.tapButton == 0 ? Color.MyColor.baseColorWB : Color(.red))

                    Spacer(minLength: 42)
                    
                    Button {
                        vm.tapButton = 1
                    } label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                         
                    }
                    .foregroundColor(vm.tapButton == 1 ? Color.MyColor.baseColorWB : Color(.red))
                    
                    Spacer(minLength: 42)
                    
                    Button {
                        vm.tapButton = 2
                    } label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .foregroundColor(vm.tapButton == 2 ? Color.MyColor.baseColorWB : Color(.red))
                    
                    Spacer(minLength: 42)
                    
                    Button {
                        vm.tapButton = 3
                    } label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                       
                    }
                    .foregroundColor(vm.tapButton == 3 ? Color.MyColor.baseColorWB : Color(.red))
                    
                    Spacer(minLength: 42)
                    
                    Button {
                        vm.tapButton = 4
                    } label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .foregroundColor(vm.tapButton == 4 ? Color.MyColor.baseColorWB : Color(.red))

                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
                .background(Color.primary.opacity(0.09))

              
            }
        }
        
        
        
        
        

    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
