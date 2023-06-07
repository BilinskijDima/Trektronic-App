//
//  Button + Style.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 7.06.23.
//

import Foundation
import SwiftUI

struct DefaultButtonImage: ButtonStyle {
    
    var name: String
    var logo: Image
    var width: CGFloat
    var height: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        HStack(alignment: .center, spacing: 8) {
            logo
                .resizable()
                .frame(width: width, height: height)
                .foregroundColor(Color.MyColor.baseColorBW)
            Text(name)
                .myTextStyle()
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.MyColor.baseColorWB)
        .cornerRadius(.greatestFiniteMagnitude)
        .overlay {
            if configuration.isPressed {
                Color(white: 0.5, opacity: 0.5)
                    .cornerRadius(.greatestFiniteMagnitude)
            }
        }
            
    }
    
}

struct DefaultButton: ButtonStyle {
    
    var name: String
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        Text(name)
            .myTextStyle()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.MyColor.baseColorWB)
            .cornerRadius(.greatestFiniteMagnitude)
            .overlay {
                if configuration.isPressed {
                    Color(white: 0.5, opacity: 0.5)
                        .cornerRadius(.greatestFiniteMagnitude)

                }
            }
    }
    
}

