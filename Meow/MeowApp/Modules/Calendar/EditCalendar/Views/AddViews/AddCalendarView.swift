//
//  AddCalendarView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct AddCalendarView: View {
    
    @EnvironmentObject var viewModel: EditViewModel
    
    var body: some View {
        Form {
            Section {
                TextField("Новый календарь", text: $viewModel.newCalendar)
            }
            Section {
                Button("Добавить", role: .none) {
                    Task {
                        await viewModel.addCalendar()
                    }
                }
                .disabled(
                    viewModel.newCalendar.isEmpty
                )
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Добавить календарь")
        .toolbarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.newCalendar = ""
        }
    }
}

#Preview {
    AddCalendarView()
        .environmentObject(EditViewModel())
}
