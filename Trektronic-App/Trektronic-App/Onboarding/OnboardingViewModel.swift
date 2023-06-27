//
//  OnboardingViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import Foundation
import SwiftUI

final class OnboardingViewModel: ObservableObject  {

    struct OnboardingStep: Hashable {
        let id: Int
        let image: String
        let title: String
        let description: String
    }
    
    @Published var currentStep = 0
    @Published var showPresetting = false
    
    @Published var onBoardingSteps = [OnboardingStep(id: 0, image: "figure.run", title: "Ходи и побеждай", description: "Ходите каждый день и достигайте своих целей"),  OnboardingStep(id: 1,image: "bitcoinsign.circle", title: "Получай монеты", description: "Получайте монеты за свою активность и достижение целей"), OnboardingStep(id: 2,image: "gauge.high", title: "Совершенствуйте свои способности", description: "Повышайте уровень своих способностей, чтобы быть первым в битвах"), OnboardingStep(id: 3, image: "chart.xyaxis.line", title: "Статистика", description: "Наблюдайте и анализируйте свой прогресс"), OnboardingStep(id: 4, image: "figure.boxing", title: "Один на один", description: "Бросайте вызов другим пользователям TreckTronic"), OnboardingStep(id: 5, image: "gearshape", title: "Осталось еще немного", description: "Давай завершим настройку и приступим к делу")
    ]

}

