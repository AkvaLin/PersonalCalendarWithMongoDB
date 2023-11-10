//
//  AddToCalendarViewModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import Foundation

class EditViewModel: ObservableObject {
    
    @Published var showCalendarsDetails = false
    @Published var showTypesDetails = false
    @Published var showEventsDetails = false
    
    @Published var newCalendar = ""
    @Published var calendars = [String]()
    
    @Published var newType = ""
    @Published var selectedCalendar: String? = nil
    @Published var types = [TypeModel]()
    
    @Published var newEvent = ""
    @Published var description = ""
    @Published var date = Date()
    @Published var guests = [String]()
    @Published var guest = ""
    @Published var selectedType: TypeModel? = nil
    @Published var events = [EventModel]()
    
    private var networkManager: NetworkManager? = nil

    public func setup(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    public func addCalendar() async {
        guard let networkManager = networkManager else { return }
        do {
            try await networkManager.addCalendar(calendar: newCalendar)
            DispatchQueue.main.async {
                self.newCalendar = ""
            }
        } catch {
            DispatchQueue.main.async {
                self.newCalendar = ""
            }
        }
    }
    
    public func loadCalendarDetails() async {
        guard let networkManager = networkManager else { return }
        do {
            let data = try await networkManager.getCalendars()
            DispatchQueue.main.async {
                self.calendars = data
            }
        } catch {
            
        }
    }
    
    public func addType() async {
        guard let networkManager = networkManager,
        let selectedCalendar = selectedCalendar
        else { return }
        do {
            try await networkManager.addTypes(calendar: selectedCalendar, type: newType)
            DispatchQueue.main.async {
                self.newType = ""
            }
        } catch {
            DispatchQueue.main.async {
                self.newType = ""
            }
        }
    }
    
    public func loadTypeDetails(for calendar: String = "") async {
        guard let networkManager = networkManager else { return }
        do {
            let data = try await networkManager.getTypes(for: calendar)
            DispatchQueue.main.async {
                self.types = data
            }
        } catch {
            
        }
    }
    
    public func addEvent() async {
        guard let networkManager = networkManager, 
        let selectedCalendar = selectedCalendar,
        let selectedType = selectedType
        else { return }
        do {
            try await networkManager.addEvent(calendar: selectedCalendar,
                                              type: selectedType,
                                              title: newEvent,
                                              description: description,
                                              date: date.timeIntervalSince1970,
                                              guests: guests)
            DispatchQueue.main.async {
                self.newEvent = ""
                self.description = ""
            }
        } catch {
            DispatchQueue.main.async {
                self.newEvent = ""
                self.description = ""
            }
        }
    }
    
    public func loadEventsDetails() async {
        guard let networkManager = networkManager else { return }
        do {
            let data = try await networkManager.getEvents()
            DispatchQueue.main.async {
                self.events = data
            }
        } catch {
            
        }
    }
    
    public func deleteEvent(index: Int) async {
        guard let networkManager = networkManager else { return }
        do {
            try await networkManager.deleteEvent(event: events[index])
        } catch {
            
        }
    }
    
    public func deleteType(index: Int) async {
        guard let networkManager = networkManager else { return }
        do {
            try await networkManager.deleteType(type: types[index])
        } catch {
            
        }
    }
    
    public func deleteCalendar(index: Int) async {
        guard let networkManager = networkManager else { return }
        do {
            try await networkManager.deleteCalendar(calendar: calendars[index])
        } catch {
            
        }
    }
}
