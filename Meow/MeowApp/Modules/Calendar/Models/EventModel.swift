//
//  EventModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import Foundation
import BSON

struct EventModel: Codable {
    var userId: ObjectId
    var calendarId: ObjectId
    var typeId: ObjectId
    var title: String
    var details: EventDescriptionModel
}

struct EventDescriptionModel: Codable {
    var description: String
    var date: TimeInterval
    var guests: [String]
}

extension EventModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension EventDescriptionModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}
