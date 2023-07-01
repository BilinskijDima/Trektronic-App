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
        
        VStack {
            
            VStack {
                
                Button {
                    if !vm.disableTextFieldName {
                        vm.showImagePicker.toggle()
                    }
                } label: {
                    
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
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 160)
                                .foregroundColor(.baseColorWB)
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
                        .buttonStyle(StyleDefaultButton(name: "Разрешить"))
                    
                    Image(systemName: vm.stateHealthKit ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(vm.stateHealthKit ? Color.green : Color.red)
                }
            }
            
            Spacer()
            
            Button {
                vm.stateSaveData()
            } label: { }
                .buttonStyle(StyleDefaultButton(name: "Давай начнем"))
                .opacity(vm.stateHealthKit && vm.stateNickname ? 1 : 0.5)
                .disabled(vm.stateHealthKit && vm.stateNickname ? false : true)
                .padding(.bottom, 42)
            
        }
        .task {
            vm.stateAutUser()
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


