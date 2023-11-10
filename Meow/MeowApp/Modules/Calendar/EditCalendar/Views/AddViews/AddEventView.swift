//
//  AddEventView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct AddEventView: View {
    
    @EnvironmentObject var viewModel: EditViewModel
    @State private var showCalendarList = false
    @State private var showTypeList = false
    
    var body: some View {
        Form {
            Section {
                TextField("Новое событие", text: $viewModel.newEvent)
            }
            Section {
                TextField("Описание", text: $viewModel.description)
                DatePicker("Время события", selection: $viewModel.date)
                HStack {
                    TextField("Гость", text: $viewModel.guest)
                    Button("Добавить") {
                        viewModel.guests.append(viewModel.guest)
                        viewModel.guest = ""
                    }
                }
            }
            if !viewModel.guests.isEmpty {
                Section("Гости:") {
                    ForEach(viewModel.guests, id: \.self) { data in
                        Text(data)
                    }
                }
            }
            Section {
                VStack(alignment: .leading) {
                    Text("Выбранный календар:")
                    Text("\(viewModel.selectedCalendar ?? "")")
                }
                .padding(.vertical, 8)
                Button(showCalendarList ? "Скрыть список" : "Показать список календарей") {
                    withAnimation(.easeInOut) {
                        showCalendarList.toggle()
                    }
                }
            }
            if showCalendarList {
                Section {
                    ForEach(viewModel.calendars, id: \.self) { calendar in
                        Button(calendar) {
                            withAnimation(.easeInOut) {
                                viewModel.selectedCalendar = calendar
                            }
                        }
                        .tint(.primary)
                    }
                }
            }
            if viewModel.selectedCalendar != nil {
                Section {
                    VStack(alignment: .leading) {
                        Text("Выбранный тип события:")
                        Text("\(viewModel.selectedType?.title ?? "")")
                    }
                    .padding(.vertical, 8)
                    Button(showTypeList ? "Скрыть список" : "Показать список типов") {
                        withAnimation(.easeInOut) {
                            showTypeList.toggle()
                        }
                    }
                }
                if showTypeList {
                    Section {
                        ForEach(viewModel.types, id: \.title) { type in
                            Button(type.title) {
                                withAnimation(.easeInOut) {
                                    viewModel.selectedType = type
                                }
                            }
                            .tint(.primary)
                        }
                    }
                }
            }
            Section {
                Button("Добавить", role: .none) {
                    Task {
                        await viewModel.addEvent()
                    }
                }
                .disabled(
                    viewModel.newEvent.isEmpty ||
                    viewModel.selectedCalendar == nil ||
                    viewModel.selectedType == nil ||
                    viewModel.description.isEmpty
                )
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Добавить событие")
        .toolbarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.newEvent = ""
            viewModel.description = ""
            viewModel.selectedCalendar = nil
            viewModel.selectedType = nil
        }
        .onChange(of: viewModel.selectedCalendar) {
            guard let calendar = viewModel.selectedCalendar else { return }
            Task {
                await viewModel.loadTypeDetails(for: calendar)
            }
        }
    }
}

#Preview {
    AddEventView()
        .environmentObject(EditViewModel())
}
