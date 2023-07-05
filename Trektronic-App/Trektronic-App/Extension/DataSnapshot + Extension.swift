//
//  DataSnapshot + Extension.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 27.06.23.
//

import Foundation
import Firebase

extension DataSnapshot {
    
    func decodeJSON<T>(type: T.Type) throws -> T where T : Decodable {
        guard let json = self.value as? [String: Any] else {fatalError()}
                
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        let user = try JSONDecoder().decode(type.self, from: data)
        
        return user
    }

}


