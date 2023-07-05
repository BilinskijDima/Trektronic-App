//
//  FireBaseModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 18.06.23.
//

import Foundation

struct Users: Hashable, Codable {
        
    var date: String
    var step: Int
    var coin: Int
    var nickname: String
    var image: String
    var favouritesUser: [String]?
    var id: String
    
    enum CodingKeys : String, CodingKey {
        case date
        case step
        case coin
        case nickname
        case image
        case favouritesUser
        case id
    }
    
}

