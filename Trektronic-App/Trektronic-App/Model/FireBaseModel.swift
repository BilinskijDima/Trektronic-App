//
//  FireBaseModel.swift
//  Trektronic-App
//
//  Created by Дмитрий Билинский on 18.06.23.
//

import Foundation
import SwiftUI

public struct UserData: Codable {

    let nickname: String?
    let registrationDate: Date?

    enum CodingKeys: String, CodingKey {
        case nickname
        case registrationDate
    }

}
