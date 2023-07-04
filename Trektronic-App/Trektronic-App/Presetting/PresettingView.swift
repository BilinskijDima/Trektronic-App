//
//  PresettingView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 24.06.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PresettingView: View {
    
    @AppStorage("stateLoadingView") var stateLoadView: LoadView = .loginView
    
    @StateObject var vm: PresettingViewModel = PresettingViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            if vm.activateIndicator {
                ProgressView()
                    .scaleEffect(3, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    .padding(.bottom, 135)
            }
            
            VStack {
                
                VStack {
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        if vm.disableTextFieldName {
                            WebImage(url: URL(string: vm.imageURL ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 160)
                                .cornerRadius(80)
                        } else {
                            if let image = vm.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 160, height: 160)
                                    .cornerRadius(80)
                            } else {
                                Image("DefaultAvatar")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 160, height: 160)
                                    .foregroundColor(.baseColorWB)
                            }
                        }
                        
                        Button {
                            if !vm.disableTextFieldName {
                                vm.showImagePicker.toggle()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.purple)
                                Image(systemName: "plus")
                                    .foregroundColor(.baseColorBW)
                            }
                        }
                        
                        
                    }
                    
                    
                    .padding(.bottom, 24)
                    
                    Text(vm.disableTextFieldName ? "Рады вас снова видеть" : "Введите уникальное имя")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    
                    HStack{
                        TextField("Введите уникальное имя", text: $vm.textFieldName)
                            .disabled(vm.disableTextFieldName)
                            .padding([.vertical, .leading], 12)
                            .colorInvert()
                            .background(Color.baseColorWB)
                            .cornerRadius(.greatestFiniteMagnitude)
                            .disableAutocorrection(true)
                            .onChange(of: vm.textFieldName) { newValue in
                                vm.textFieldName = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                            .onSubmit {
                                vm.checkNickname()
                            }
                        
                        Image(systemName: vm.stateNickname ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(vm.stateNickname ? Color.green : Color.red)
                        
                    }
                    
                    Text(vm.errorText)
                        .foregroundColor(.red)
                    
                }
                .padding(.top, 24)
                .padding(.bottom, 8)
                
                VStack {
                    
                    Text("Доступ HealthKit")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    HStack{
                        Button {
                            vm.requestAuthorisation()
                        } label:{}
                            .buttonStyle(StyleDefaultButton(name: "Разрешить", colorBG: Color.baseColorWB))
                        
                        Image(systemName: vm.stateHealthKit ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(vm.stateHealthKit ? Color.green : Color.red)
                    }
                }
                
                Spacer()
                
                Button {
                    vm.stateSaveData()
                    vm.activateIndicator = true
                } label: { }
                    .buttonStyle(StyleDefaultButton(name: "Давай начнем", colorBG: Color.baseColorWB))
                    .opacity(vm.stateHealthKit && vm.stateNickname ? 1 : 0.5)
                    .disabled(vm.stateHealthKit && vm.stateNickname ? false : true)
                    .padding(.bottom, 42)
                
            }
            
            
        }
        .alert(item: $vm.alert) { value in
            return value.alert
        }
        .task {
            vm.stateAutUser()
            vm.authorizationStatusHK()
        }
        .padding(.horizontal, 24)
        .fullScreenCover(isPresented: $vm.showImagePicker) {
            ImagePicker(image: $vm.image)
        }
    }
}

struct PresettingView_Previews: PreviewProvider {
    static var previews: some View {
        PresettingView()
    }
}


