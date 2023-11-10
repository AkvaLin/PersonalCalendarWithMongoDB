//
//  EventsView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import SwiftUI

struct EventsView: View {
    
    @EnvironmentObject var networkManager: NetworkManager
    @StateObject var viewModel: EventsViewModel
    
    
    var body: some View {
        List(viewModel.events, id: \.self) { event in
            NavigationLink(event.title) {
                EventView(model: event)
            }
        }
        .listStyle(.inset)
        .navigationTitle(viewModel.type.title)
        .onAppear {
            Task {
                await viewModel.setup(networkManager: networkManager)
            }
        }
    }
}
