//
//  EditEventView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import SwiftUI

struct EditEventView: View {
    public let event: EventModel
    @EnvironmentObject var networkManager: NetworkManager
    @State var newTitle = ""
    @State var description = ""
    @State var date = Date()
    @State var guests = [String]()
    @State var guest = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Новый календарь", text: $newTitle)
                TextField("Описание", text: $description)
                DatePicker("Дата", selection: $date)
                HStack {
                    TextField("Гость", text: $guest)
                    Button("Добавить") {
                        guests.append(guest)
                        guest = ""
                    }
                }
            }
            if !guests.isEmpty {
                Section("Гости:") {
                    ForEach(guests, id: \.self) { data in
                        Text(data)
                    }
                }
            }
            Section {
                Button("Обновить") {
                    Task {
                        do {
                            try await networkManager.updateEvent(event: event, title: newTitle, description: description, date: date.timeIntervalSince1970, guests: guests)
                        } catch {
                            
                        }
                        DispatchQueue.main.async {
                            newTitle = ""
                        }
                    }
                }
                .disabled(
                    newTitle.isEmpty
                )
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(event.title)
        .toolbarTitleDisplayMode(.inline)
        .onAppear {
            description = event.details.description
            date = Date(timeIntervalSince1970: event.details.date)
        }
    }
}
