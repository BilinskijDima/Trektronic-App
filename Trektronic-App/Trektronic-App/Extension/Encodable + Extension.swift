//
//  Encodable + Extension.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 27.06.23.
//

import Foundation

extension Encodable {
    
    var toDictionary: [String: Any]?{
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
    
}
