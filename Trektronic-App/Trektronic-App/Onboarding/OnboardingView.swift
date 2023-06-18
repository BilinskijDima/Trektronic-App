//
//  OnboardingView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("stateLoadView") var stateLoadView = DefaultSettings.stateLoadHomeView
    @AppStorage("stateLoadHealthKit") var stateLoadHealthKit = DefaultSettings.stateLoadHealthKit
        
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
                        
                        Button {
                            Task {
                                stateLoadHealthKit = try await vm.healthKitManager.requestAuthorisation()
                            }
                        } label: {
                            Text("Button")
                        }
                        
                    }
                    .tag(step.id)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
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
                    withAnimation(.easeInOut(duration: 0.3)) {
                        vm.currentStep += 1
                    }
                } else {
                    stateLoadView.toggle()
                }
            } label: { }
                .buttonStyle(StyleDefaultButton(name: vm.currentStep < vm.onBoardingSteps.count - 1 ? "Далее" : "Давай начнем"))
                .padding(.bottom, 42)
                .padding(.horizontal, 24)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
