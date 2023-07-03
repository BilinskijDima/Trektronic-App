//
//  SettingsView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 25.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SettingsView: View {
    
    @StateObject var vm: SettingsViewModel = SettingsViewModel()

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
          
                VStack {
                    
                    Button {
                        vm.showImagePicker.toggle()
                    } label: {
                        WebImage(url: URL(string: vm.user?.image ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(50)
                    }
                    .padding(.top, 24)
                    
                    Text(vm.user?.nickname ?? "")
                        .bold()
                        .font(.system(size: 35))
                        .foregroundColor(.baseColorWB)
                        .padding(.bottom, 8)
                    
                    HStack{
                        TextField("Новое имя", text: $vm.textFieldName)
                            .padding([.vertical, .leading], 12)
                            .colorInvert()
                            .background(Color.baseColorWB)
                            .cornerRadius(.greatestFiniteMagnitude)
                            .disableAutocorrection(true)
                            .onChange(of: vm.textFieldName) { newValue in
                                vm.textFieldName = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        
                        Button {
                            vm.checkNickname()
                        } label: { }
                            .buttonStyle(StyleDefaultButton(name: "Изменить"))
                    }
                    
                    Text(vm.errorText)
                        .foregroundColor(.red)
                        .padding(.bottom , 100)
                
                    
                    Button {
                        vm.singOut()
                    } label: { }
                        .buttonStyle(StyleDefaultButton(name: "Выйти из профиля"))
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 24)

            }
            .navigationTitle("Настройки")
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.baseColorWB)
                }
            }
        }
        .task {
            vm.fetchDataUser()
        }
      
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
