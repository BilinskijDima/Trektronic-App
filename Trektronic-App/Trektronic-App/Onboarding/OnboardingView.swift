//
//  OnboardingView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("stateLoadingView") var stateLoadView: LoadView = .loginView
    @StateObject var vm: OnboardingViewModel = OnboardingViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
           
            TabView(selection: $vm.currentStep) {
                ForEach(vm.onBoardingSteps, id: \.id) { step in
                    VStack {
                        Image(step.image)
                            .resizable()
                            .frame(width: 150, height: 150)
                        
                        VStack {
                            
                            VStack(spacing: 8) {
                                
                                Text(step.title)
                                    .foregroundColor(Color.baseColorBW)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .bold()
                                
                                Text(step.description)
                                    .foregroundColor(Color.baseColorBW)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.center)
                                
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.baseColorWB)
                        .cornerRadius(24)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(24)
                    .tag(step.id)
                    .padding(.horizontal, 24)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack(spacing: 16) {
                ForEach(vm.onBoardingSteps, id: \.id) { step in
                    Capsule ()
                        .foregroundColor(Color.baseColorWB)
                        .frame(width: step.id == vm.currentStep ? 20 : 10, height: 10)
                        .animation(.easeInOut, value: vm.currentStep)
                        }
            }
            .padding(.bottom, 42)
            
            Spacer()
            
            Button {
                if vm.currentStep < vm.onBoardingSteps.count - 1 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        vm.currentStep += 1
                    }
                } else {
                   // vm.showPresetting = true
                    self.stateLoadView = .presettingView
                }
            } label: { }
                .buttonStyle(StyleDefaultButton(name: vm.currentStep < vm.onBoardingSteps.count - 1 ? "Далее" : "Завершить настройку"))
                .padding(.bottom, 42)
                .padding(.horizontal, 24)
            
        }
      // .fullScreenCover(isPresented: $vm.showPresetting) { PresettingView() }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }

}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
