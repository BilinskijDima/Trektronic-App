//
//  SettingsView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 25.06.23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var vm: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
          
                VStack {
                    
                    Button {
                        vm.singOut()
                    } label: { }
                        .buttonStyle(StyleDefaultButton(name: "Выйти из профиля"))
                }
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
      
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
