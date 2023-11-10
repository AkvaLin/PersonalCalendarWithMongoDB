//
//  TypeModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import Foundation
import BSON

struct TypeModel: Codable {
    var userId: ObjectId
    var calendarId: ObjectId
    var title: String
}

extension TypeModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
