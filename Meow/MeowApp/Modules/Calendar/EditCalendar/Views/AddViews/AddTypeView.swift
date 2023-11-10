//
//  AddTypeView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct AddTypeView: View {
    
    @EnvironmentObject var viewModel: EditViewModel
    @State private var showList = false
    
    var body: some View {
        Form {
            Section {
                TextField("Новый тип события", text: $viewModel.newType)
            }
            Section {
                VStack(alignment: .leading) {
                    Text("Выбранный календар:")
                    Text("\(viewModel.selectedCalendar ?? "")")
                }
                .padding(.vertical, 8)
                Button(showList ? "Скрыть список" : "Показать список календарей") {
                    withAnimation(.easeInOut) {
                        showList.toggle()
                    }
                }
            }
            if showList {
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
            Section {
                Button("Добавить", role: .none) {
                    Task {
                        await viewModel.addType()
                    }
                }
                .disabled(
                    viewModel.newType.isEmpty ||
                    viewModel.selectedCalendar == nil
                )
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Добавить тип события")
        .toolbarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.newType = ""
            viewModel.selectedCalendar = nil
        }
    }
}

#Preview {
    AddTypeView()
        .environmentObject(EditViewModel())
}
