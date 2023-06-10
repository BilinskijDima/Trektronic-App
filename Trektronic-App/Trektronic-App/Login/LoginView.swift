//
//  LoginView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var vm: LoginViewModel = LoginViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            VStack(spacing: 0) {
                
                Image("AppLogo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 16)
                
                Text("TrekTronic")
                    .foregroundColor(Color.baseColorWB)
                    .fontWeight(.bold)
                    .font(.system(size: 36))
                
                Text("больше чем просто трекер")
                    .foregroundColor(Color.baseColorWB)
                    .fontWeight(.regular)
                    .font(.system(size: 13))
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button {
                    vm.singInWithGoogle()
                } label: { }
                    .buttonStyle(StyleDefaultButtonImage(name: "Войти через Google", logo: Image("GoogleLogo"), width: 25, height: 25))
                
                Button {
                   
                } label: { }
                    .buttonStyle(StyleDefaultButtonImage(name: "Войти через Apple", logo: Image(systemName: "apple.logo"), width: 25, height: 28.5))
            }
            .padding(.bottom, 42)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        
        .fullScreenCover(isPresented: $vm.showScreen) { OnboardingView() }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
