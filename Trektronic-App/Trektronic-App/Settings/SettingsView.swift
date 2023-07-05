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
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        if let image = vm.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 160)
                                .cornerRadius(80)
                        } else {
                            WebImage(url: URL(string: vm.user?.image ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 160)
                                .cornerRadius(80)
                        }
                        
                        Button {
                            vm.showImagePicker.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.blue)
                                Image(systemName: "plus")
                                    .foregroundColor(.baseColorBW)
                            }
                        }
                    }
                    .padding(.vertical, 24)
                    
                    Button {
                        vm.saveImage()
                    } label: { }
                        .buttonStyle(StyleDefaultButton(name: "Сохранить новое фото", colorBG: Color.baseColorWB))
                    
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
                            .buttonStyle(StyleDefaultButton(name: "Изменить", colorBG: Color.baseColorWB))
                        
                    }
                    
                    Text(vm.errorText)
                        .foregroundColor(.red)
                        .padding(.bottom , 100)
                    
                    Button {
                        vm.singOut()
                    } label: { }
                        .buttonStyle(StyleDefaultButton(name: "Выйти из профиля", colorBG: Color.red))
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 24)
                
            }
            .alert(item: $vm.alert) { value in
                value.alert
            }
            
            .navigationTitle("Настройки")
            
            .toolbar {
                Button {
                    vm.isShowingInfo = true
                } label: {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.baseColorWB)
                }
            }
        }
        .task {
            vm.fetchDataUser()
        }
        .fullScreenCover(isPresented: $vm.showImagePicker) {
            ImagePicker(image: $vm.image)
        }
        .sheet(isPresented: $vm.isShowingInfo) {
            InfoView(nameView: "Экран Настроек", infoText: "Информация об экране")
        }
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
