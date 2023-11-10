//
//  NetworkManager.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import Foundation
import MongoKitten

class NetworkManager: ObservableObject {
    
    @Published var showNetworkError = false
    @Published var connected = false
    var db: MongoDatabase? = nil
    
    public func onAppear() async {
        do {
            db = try await MongoDatabase.connect(to: "mongodb://172.20.10.3:27017/Calendar")
            DispatchQueue.main.async {
                self.connected = true
            }
        } catch {
            db = nil
            DispatchQueue.main.async {
                self.showNetworkError = true
            }
        }
    }
    
    // MARK: - Login & Register
    
    public func checkLogin(login: String, password: String) async -> Bool {
        guard let db = db else { return false }
        let accounts = db["Account"]
        do {
            guard let account = try await accounts.findOne(["login": login, "password": password]) else { return false }
            guard let id = account["_id"] else { return false }
            UserDefaults.standard.login = login
            UserDefaults.standard.password = password
            UserDefaults.standard.id = "\(id)"
            return true
        } catch {
            return false
        }
    }
    
    public func register(login: String, password: String) async throws -> Bool {
        guard let db = db else { return false }
        let accounts = db["Account"]
        do {
            if let _ = try await accounts.findOne(["login": login]) {
                throw NSError()
            } else {
                try await accounts.insert(["login": login, "password": password])
                return true
            }
        } catch {
            return false
        }
    }
    
    // MARK: - Edit Profile
    
    public func changeLogin(login: String, newLogin: String) async throws -> Bool {
        guard let db = db else { return false }
        let accounts = db["Account"]
        do {
            if let _ = try await accounts.findOne(["login": newLogin]) {
                throw NSError()
            } else {
                guard let account = try await accounts.findOne(["login": login]) else { return false }
                var newAccount = account
                newAccount["login"] = newLogin
                try await accounts.updateOne(where: account, to: newAccount)
                return true
            }
        } catch {
            return false
        }
    }
    
    public func changePassword(login: String, password: String) async throws {
        guard let db = db else { throw NSError() }
        let accounts = db["Account"]
        do {
            guard let account = try await accounts.findOne(["login": login]) else { return }
            var newAccount = account
            newAccount["password"] = password
            try await accounts.updateOne(where: account, to: newAccount)
        } catch let error {
            throw error
        }
    }
    
    // MARK: - Edit & Get Calendar
    
    public func addCalendar(calendar: String) async throws {
        guard let db = db else { throw NSError() }
        let calendars = db["CalendarType"]
        guard let id = ObjectId(UserDefaults.standard.id) else { return }
        do {
            try await calendars.insert(["userId": id, "title": calendar])
        } catch let error {
            throw error
        }
    }
    
    public func getCalendars() async throws -> [String] {
        guard let db = db else { return [] }
        let calendars = db["CalendarType"]
        guard let id = ObjectId(UserDefaults.standard.id) else { return [] }
        do {
            let calendars = try await calendars.find(["userId": id]).drain()
            return calendars.map { document in
                guard let document = document["title"] else { return "" }
                return "\(document)"
            }
        } catch let error {
            throw error
        }
    }
    
    public func addTypes(calendar: String, type: String) async throws {
        guard let db = db else { return }
        guard let id = ObjectId(UserDefaults.standard.id) else { return }
        do {
            guard let calendarIdObject = await getCalendarId(calendar: calendar) else { return }
            let types = db["EventType"]
            try await types.insert(["userId": id, "calendarId": calendarIdObject, "title": type])
        } catch let error {
            throw error
        }
    }
    
    public func getTypes(for calendar: String = "") async throws -> [TypeModel] {
        guard let db = db else { return [] }
        let eventTypes = db["EventType"]
        guard let id = ObjectId(UserDefaults.standard.id) else { return [] }
        do {
            var types = [FindQueryBuilder.Element]()
            switch calendar {
            case "":
                types = try await eventTypes.find(["userId": id]).drain()
            default:
                guard let calendarId = await getCalendarId(calendar: calendar) else { return [] }
                types = try await eventTypes.find(["userId": id, "calendarId": calendarId]).drain()
            }
            return types.compactMap { document in
                let type = try? BSONDecoder().decode(TypeModel.self, from: document)
                return type
            }
        } catch let error {
            throw error
        }
    }
    
    public func addEvent(calendar: String, type: TypeModel, title: String, description: String, date: TimeInterval, guests: [String]) async throws {
        guard let db = db else { return }
        let events = db["Event"]
        print(0)
        guard let id = ObjectId(UserDefaults.standard.id) else { return }
        do {
            guard let calendarIdObject = await getCalendarId(calendar: calendar) else { return }
            guard let typeIdObject = await getTypeId(type: type) else { return }
            let event = EventModel(userId: id,
                                   calendarId: calendarIdObject,
                                   typeId: typeIdObject,
                                   title: title,
                                   details: EventDescriptionModel(description: description,
                                                                  date: date,
                                                                  guests: guests))
            try await events.insertEncoded(event)
        } catch let error {
            print(error)
            throw error
        }
    }
    
    public func getEvents(for calendar: String = "", type: TypeModel? = nil) async throws -> [EventModel] {
        guard let db = db else { return [] }
        let eventList = db["Event"]
        guard let id = ObjectId(UserDefaults.standard.id) else { return [] }
        do {
            var events = [FindQueryBuilder.Element]()
            if !calendar.isEmpty && type != nil {
                guard let calendarId = await getCalendarId(calendar: calendar) else { return [] }
                guard let typeId = await getTypeId(type: type!) else { return [] }
                events = try await eventList.find(["userId": id, "calendarId": calendarId, "typeId": typeId]).drain()
            } else if !calendar.isEmpty {
                guard let calendarId = await getCalendarId(calendar: calendar) else { return [] }
                events = try await eventList.find(["userId": id, "calendarId": calendarId]).drain()
            } else {
                events = try await eventList.find(["userId": id]).drain()
            }
            return events.compactMap { document in
                let event = try? BSONDecoder().decode(EventModel.self, from: document)
                return event
            }
        } catch let error {
            throw error
        }
    }
    
    // MARK: - Delete
    
    public func deleteEvent(event: EventModel) async throws {
        guard let db = db else { return }
        let eventList = db["Event"]
        do {
            let document = try BSONEncoder().encode(event)
            try await eventList.deleteOne(where: document)
        } catch let error {
            throw error
        }
    }
    
    public func deleteType(type: TypeModel) async throws {
        guard let db = db else { return }
        let types = db["EventType"]
        let eventList = db["Event"]
        do {
            guard let typeId = await getTypeId(type: type) else { return }
            try await eventList.deleteAll(where: ["typeId": typeId])
            try await types.deleteOne(where: ["_id": typeId])
        } catch let error {
            throw error
        }
    }
    
    public func deleteCalendar(calendar: String) async throws {
        guard let db = db else { return }
        let calendars = db["CalendarType"]
        let types = db["EventType"]
        let eventList = db["Event"]
        do {
            guard let calendarId = await getCalendarId(calendar: calendar) else { return }
            try await eventList.deleteAll(where: ["calendarId": calendarId])
            try await types.deleteAll(where: ["calendarId": calendarId])
            try await calendars.deleteOne(where: ["_id": calendarId])
        } catch let error {
            throw error
        }
    }
    
    public func deleteAll() async throws {
        guard let db = db else { return }
        let account = db["Account"]
        let calendars = db["CalendarType"]
        let types = db["EventType"]
        let eventList = db["Event"]
        guard let id = ObjectId(UserDefaults.standard.id) else { return }
        do {
            try await eventList.deleteAll(where: ["userId": id])
            try await types.deleteAll(where: ["userId": id])
            try await calendars.deleteAll(where: ["userId": id])
            try await account.deleteOne(where: ["_id": id])
        } catch let error {
            throw error
        }
    }
    
    // MARK: - Update
    
    public func updateCalendar(calendarTitle: String, title: String) async throws {
        guard let db = db else { return }
        let calendars = db["CalendarType"]
        do {
            guard let id = await getCalendarId(calendar: calendarTitle) else { return }
            guard let calendar = try await calendars.findOne(["_id": id]) else { return }
            var newCalendar = calendar
            newCalendar["title"] = title
            try await calendars.updateOne(where: calendar, to: newCalendar)
        } catch let error {
            throw error
        }
    }
    
    public func updateType(type: TypeModel, title: String) async throws {
        guard let db = db else { return }
        let types = db["EventType"]
        do {
            guard let id = await getTypeId(type: type) else { return }
            guard let type = try await types.findOne(["_id": id]) else { return }
            var newType = type
            newType["title"] = title
            try await types.updateOne(where: type, to: newType)
        } catch let error {
            throw error
        }
    }
    
    public func updateEvent(event: EventModel, title: String, description: String, date: TimeInterval, guests: [String]) async throws {
        guard let db = db else { return }
        let events = db["Event"]
        do {
            let document = try BSONEncoder().encode(event)
            guard let event = try await events.findOne(document) else { return }
            let data = try BSONEncoder().encode(EventDescriptionModel(description: description, date: date, guests: guests))
            var newEvent = event
            newEvent["title"] = title
            newEvent["details"] = data
            try await events.updateOne(where: event, to: newEvent)
        } catch let error {
            throw error
        }
    }
    
    // MARK: - Get Id
    
    private func getCalendarId(calendar: String) async -> ObjectId? {
        guard let db = db else { return nil }
        let calendars = db["CalendarType"]
        guard let id = ObjectId(UserDefaults.standard.id) else { return nil }
        do {
            let calendar = try await calendars.findOne(["title": calendar, "userId": id])
            guard let calendar = calendar else { return nil }
            guard let calendarId = calendar["_id"] else { return nil }
            guard let calendarIdObject = calendarId as? ObjectId else { return nil }
            return calendarIdObject
        } catch {
            return nil
        }
    }
    
    private func getTypeId(type: TypeModel) async -> ObjectId? {
        guard let db = db else { return nil }
        let types = db["EventType"]
        do {
            let encoded = try BSONEncoder().encode(type)
            let type = try await types.findOne(encoded)
            guard let type = type else { return nil }
            guard let typeId = type["_id"] else { return nil }
            guard let typeIdObject = typeId as? ObjectId else { return nil }
            return typeIdObject
        } catch {
            return nil
        }
    }
    
    // MARK: -
    
    public func group() async -> [ItemModel] {
        guard let db = db else { return [] }
        let eventList = db["Event"]
        guard let id = ObjectId(UserDefaults.standard.id) else { return [] }
        let pipeline = eventList.buildAggregate {
            Match(where: "userId" == id)
            Lookup(from: "EventType", localField: "typeId", foreignField: "_id", as: "type")
            Lookup(from: "CalendarType", localField: "calendarId", foreignField: "_id", as: "calendar")
        }
        do {
            let cursor = try await pipeline.execute()
            let data = try await cursor.cursor.drain()
            return data.compactMap { document in
                let item = try? BSONDecoder().decode(ItemModel.self, from: document)
                return item
            }
        } catch {
            return []
        }
    }
}
