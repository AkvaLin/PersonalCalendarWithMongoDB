//
//  EditCalendarView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import SwiftUI

struct EditCalendarView: View {
    
    public let title: String
    @EnvironmentObject var networkManager: NetworkManager
    @State var newCalendar = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Новый календарь", text: $newCalendar)
            }
            Section {
                Button("Обновить") {
                    Task {
                        do {
                            try await networkManager.updateCalendar(calendarTitle: title, title: newCalendar)
                        } catch {
                            
                        }
                        DispatchQueue.main.async {
                            newCalendar = ""
                        }
                    }
                }
                .disabled(
                    newCalendar.isEmpty
                )
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(title)
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    EditCalendarView(title: "")
}
