//
//  CalendarView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var networkManager: NetworkManager
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    if viewModel.isGridEnabled {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(), GridItem()], content: {
                                ForEach(viewModel.results) { item in
                                    VStack(alignment: .leading) {
                                        Text("Событие:")
                                            .font(.headline)
                                        Group {
                                            Text(item.title)
                                                .font(.headline)
                                            Text("Описание: \(item.details.description)")
                                                .font(.callout)
                                            Text("Запланированная дата: \(Date(timeIntervalSince1970: item.details.date).formatted())")
                                                .font(.caption)
                                            Text("Календарь: \(item.calendar[0].title)")
                                                .font(.footnote)
                                        }
                                        .padding(.bottom, 4)
                                        Text("Группа: \(item.type[0].title)")
                                            .font(.footnote)
                                    }
                                    .foregroundStyle(.white)
                                    .padding(8)
                                    .frame(width: 160, height: 280)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(.accent)
                                    }
                                }
                            })
                        }
                    } else {
                        List(viewModel.calendars, id: \.self) { calendar in
                            NavigationLink(calendar) {
                                TypeView(viewModel: TypeViewModel(title: calendar))
                                    .environmentObject(networkManager)
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
            .navigationTitle("Календарь")
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            if !viewModel.isGridEnabled {
                                await viewModel.doSearch()
                            }
                            viewModel.isGridEnabled.toggle()
                        }
                    } label: {
                        Image(systemName: viewModel.isGridEnabled ? "square.grid.2x2.fill" : "list.star")
                    }
                }
            }
            .padding(.horizontal)
        }
        .onChange(of: networkManager.connected) {
            Task {
                await viewModel.setup(networkManager: networkManager)
            }
        }
        .onAppear {
            Task {
                await viewModel.setup(networkManager: networkManager)
            }
        }
    }
}

#Preview {
    CalendarView()
        .environmentObject(NetworkManager())
}
