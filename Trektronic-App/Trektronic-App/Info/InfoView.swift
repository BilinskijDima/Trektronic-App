//
//  InfoView.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 3.07.23.
//

import SwiftUI

struct InfoView: View {
    
    var nameView: String
    var infoText: String
    
    var body: some View {
        
        VStack {
            Text(nameView)
                .bold()
                .font(.system(size: 35))
                .padding(.top, 24)
            
            Text(infoText)
        }
        
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(nameView: .init(), infoText: .init())
    }
}
