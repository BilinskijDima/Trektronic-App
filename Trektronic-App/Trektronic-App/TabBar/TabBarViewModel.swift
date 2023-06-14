//
//  TabBarViewModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import Foundation
import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case message
    case person
    case folder
    case gearshape
    
    var color: Color {
        switch self {
        case .house:
            return .gray
        case .message:
            return .gray
        case .person:
            return .gray
        case .folder:
            return .gray
        case .gearshape:
            return .gray
        }
    }
}

final class TabBarViewModel: ObservableObject  {
    
    @Published var selectedTab: Tab = .house
    let selectedColor: Color = .green
    
}
