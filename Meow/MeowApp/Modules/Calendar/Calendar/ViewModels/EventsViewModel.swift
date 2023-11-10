//
//  EventsViewModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import Foundation

class EventsViewModel: ObservableObject {
    public let calendar: String
    public let type: TypeModel
    @Published var events = [EventModel]()
    private var networkManager: NetworkManager? = nil
    
    init(calendar: String, type: TypeModel) {
        self.calendar = calendar
        self.type = type
    }
    
    public func setup(networkManager: NetworkManager) async {
        self.networkManager = networkManager
        do {
            let events = try await networkManager.getEvents(for: calendar, type: type)
            DispatchQueue.main.async {
                self.events = events
            }
        } catch {
            
        }
    }
}

