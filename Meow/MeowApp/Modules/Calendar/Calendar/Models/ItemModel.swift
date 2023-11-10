//
//  ItemModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import Foundation

struct ItemModel: Codable, Identifiable, Hashable {
    let id = UUID()
    let title: String
    let details: Description
    let type: [EventTypeModel]
    let calendar: [CalendarTypeModel]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Description: Codable, Hashable {
    let id = UUID()
    let description: String
    let date: TimeInterval
    let guests: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct EventTypeModel: Codable, Hashable {
    let title: String
    let id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CalendarTypeModel: Codable, Hashable {
    let title: String
    let id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
