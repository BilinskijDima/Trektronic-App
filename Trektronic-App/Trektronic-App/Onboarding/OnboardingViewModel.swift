//
//  OnboardingViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import Foundation

final class OnboardingViewModel: ObservableObject  {
    
    struct OnboardingStep: Hashable {
        let id: Int
        let image: String
        let title: String
        let description: String
    }
    
    @Published var currentStep = 0
    
    @Published var onBoardingSteps = [OnboardingStep(id: 0, image: "AppLogo", title: "Text title 1", description: "Text description 1"),  OnboardingStep(id: 1,image: "AppLogo", title: "Text title 2", description: "Text description 2"), OnboardingStep(id: 2,image: "AppLogo", title: "Text title 3", description: "Text description 3"),    OnboardingStep(id: 3, image: "AppLogo", title: "Text title 4", description: "Text description 4"), OnboardingStep(id: 4, image: "AppLogo", title: "Text title 5", description: "Text description 5")
    ]
}

