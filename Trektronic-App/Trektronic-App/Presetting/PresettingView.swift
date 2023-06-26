//
//  PresettingView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 24.06.23.
//

import SwiftUI

struct PresettingView: View {
    
    @AppStorage("stateLoadingView") var stateLoadView: LoadView = .loginView

    @StateObject var vm: PresettingViewModel = PresettingViewModel()
  
    var body: some View {
        
        VStack {
            Spacer()
            
            VStack {
                
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
                    
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(vm.stateNickname ? Color.green : Color.baseColorWB)
                    
                }
            }
            .padding(.bottom, 24)
            
            VStack {
                
                Text("Доступ HealthKit")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                HStack{
                    Button {
                        vm.requestAuthorisation()
                    } label:{}
                        .buttonStyle(StyleDefaultButton(name: "Разрешить"))
                    
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(vm.stateHealthKit ? Color.green : Color.baseColorWB)
                }
            }
            
            Spacer()
            
            Button {
                //vm.stateAutUser()
                if vm.setData {
                    vm.setDataRealTime()
                } else {
                    self.stateLoadView = .tabBarView
                }
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
        .alert("Извините такое имя уже занято", isPresented: $vm.showAlertName) {
            Button("OK", role: .cancel) { }
        }
        .alert("Вы не ввели имя", isPresented: $vm.showAlertNameIsEmpty) {
            Button("OK", role: .cancel) { }
        }
        
    }
}

struct PresettingView_Previews: PreviewProvider {
    static var previews: some View {
        PresettingView()
    }
}


