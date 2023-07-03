//
//  String + Extension.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 28.06.23.
//

import Foundation

extension String {
    
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: self)
        return date
    }

}

