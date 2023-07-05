//
//  Extension + Text.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 6.06.23.
//

import SwiftUI

extension Text {

    func myTextStyle() -> some View {
        self.foregroundColor(Color.baseColorBW)
            .fontWeight(.bold)
            .font(.system(size: 18))
    }

}
