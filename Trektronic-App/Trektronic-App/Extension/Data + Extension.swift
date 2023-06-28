//
//  Data + Extension.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 11.06.23.
//

import Foundation

extension Date {
    
    static func mondayAt12AM() -> Date {
        Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
    }

    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents (year: year, month: month, day: day)
        guard let date = Calendar.current.date(from: components) else { fatalError() }
        return date
    }
    
}
