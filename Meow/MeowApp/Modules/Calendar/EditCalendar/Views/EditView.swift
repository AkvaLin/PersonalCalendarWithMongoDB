//
//  AddToCalendarView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var networkManager: NetworkManager
    @StateObject private var viewModel = EditViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Календари") {
                    NavigationLink("Добавить") {
                        AddCalendarView()
                            .environmentObject(viewModel)
                    }
                    Button(viewModel.showCalendarsDetails ? "Скрыть подробности" : "Подробнее") {
                        Task {
                            await viewModel.loadCalendarDetails()
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut) {
                                    viewModel.showCalendarsDetails.toggle()
                                }
                            }
                        }
                    }
                }
                if viewModel.showCalendarsDetails {
                    Section {
                        ForEach(viewModel.calendars, id: \.self) { calendar in
                            NavigationLink(calendar) {
                                EditCalendarView(title: calendar)
                                    .environmentObject(networkManager)
                            }
                        }
                        .onDelete(perform: deleteCalendar)
                    }
                }
                Section("Типы событий") {
                    NavigationLink("Добавить") {
                        AddTypeView()
                            .environmentObject(viewModel)
                            .onAppear {
                                Task {
                                    await viewModel.loadCalendarDetails()
                                }
                            }
                    }
                    Button(viewModel.showTypesDetails ? "Скрыть подробности" : "Подробнее") {
                        Task {
                            await viewModel.loadTypeDetails()
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut) {
                                    viewModel.showTypesDetails.toggle()
                                }
                            }
                        }
                    }
                }
                if viewModel.showTypesDetails {
                    Section {
                        ForEach(viewModel.types, id: \.title) { type in
                            NavigationLink(type.title) {
                                EditTypeView(type: type)
                                    .environmentObject(networkManager)
                            }
                        }
                        .onDelete(perform: deleteType)
                    }
                }
                Section("События") {
                    NavigationLink("Добавить") {
                        AddEventView()
                            .environmentObject(viewModel)
                            .onAppear {
                                viewModel.date = Date()
                                Task {
                                    await viewModel.loadCalendarDetails()
                                }
                            }
                    }
                    Button(viewModel.showEventsDetails ? "Скрыть подробности" : "Подробнее") {
                        Task {
                            await viewModel.loadEventsDetails()
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut) {
                                    viewModel.showEventsDetails.toggle()
                                }
                            }
                        }
                    }
                }
                if viewModel.showEventsDetails {
                    Section {
                        ForEach(viewModel.events, id: \.title) { event in
                            NavigationLink(event.title) {
                                EditEventView(event: event)
                                    .environmentObject(networkManager)
                            }
                        }
                        .onDelete(perform: deleteEvent)
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Изменить")
        }
        .onAppear {
            viewModel.setup(networkManager: networkManager)
        }
    }
    
    func deleteCalendar(at offsets: IndexSet) {
        Task {
            guard let index = offsets.first else { return }
            await viewModel.deleteCalendar(index: index)
        }
    }
    
    func deleteType(at offsets: IndexSet) {
        Task {
            guard let index = offsets.first else { return }
            await viewModel.deleteType(index: index)
        }
    }
    
    func deleteEvent(at offsets: IndexSet) {
        Task {
            guard let index = offsets.first else { return }
            await viewModel.deleteEvent(index: index)
        }
    }
}

#Preview {
    EditView()
        .environmentObject(NetworkManager())
}
