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
                ForEach(0..<vm.onBoardingSteps.count, id: \.self) { step in
                    VStack {
                        Image(vm.onBoardingSteps[step].image)
                            .resizable()
                            .frame(width: 250, height: 250)
                        Text(vm.onBoardingSteps[step].title)
                        Text(vm.onBoardingSteps[step].description)
                    }
                    .tag(step)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(0..<vm.onBoardingSteps.count, id: \.self) { step in
                    Capsule ()
                        .foregroundColor(Color.MyColor.baseColorWB)
                        .frame(width: step == vm.currentStep ? 20 : 10, height: 10)
                }
              
            }
            .padding(.bottom, 42)
            
            Spacer()
            
            Button {
                if vm.currentStep < vm.onBoardingSteps.count - 1 {
                    vm.currentStep += 1
                } else {
                    vm.showScreen = true
                }
            } label: { }
                .buttonStyle(DefaultButton(name: vm.currentStep < vm.onBoardingSteps.count - 1 ? "Далее" : "Давай начнем"))
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
