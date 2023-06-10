//
//  OnboardingView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI

struct OnboardingView: View {
        
    @StateObject var vm: OnboardingViewModel = OnboardingViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
           
            TabView(selection: $vm.currentStep) {
                ForEach(vm.onBoardingSteps, id: \.id) { step in
                    VStack {
                        Image(step.image)
                            .resizable()
                            .frame(width: 250, height: 250)
                        Text(step.title)
                        Text(step.description)
                    }
                    .tag(step.id)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            HStack(spacing: 16) {
                ForEach(vm.onBoardingSteps, id: \.id) { step in
                    Capsule ()
                        .foregroundColor(Color.baseColorWB)
                        .frame(width: step.id == vm.currentStep ? 20 : 10, height: 10)
                        }
            }
            .padding(.bottom, 42)
            
            Spacer()
            
            Button {
                if vm.currentStep < vm.onBoardingSteps.count - 1 {
                    withAnimation(.easeInOut(duration: 0.45)) {     // анимацию при нажатии кнопки получилось добавить а вот при свайпе нет (
                        vm.currentStep += 1
                    }
                } else {
                    vm.showScreen = true
                }
            } label: { }
                .buttonStyle(StyleDefaultButton(name: vm.currentStep < vm.onBoardingSteps.count - 1 ? "Далее" : "Давай начнем"))
                .padding(.bottom, 42)
                .padding(.horizontal, 24)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $vm.showScreen) { TabBarView() }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
