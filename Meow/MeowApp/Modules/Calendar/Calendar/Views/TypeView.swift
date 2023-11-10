//
//  TypeView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import SwiftUI

struct TypeView: View {
    
    @EnvironmentObject var networkManager: NetworkManager
    @StateObject var viewModel: TypeViewModel
    
    
    var body: some View {
        List(viewModel.types, id: \.self) { type in
            NavigationLink(type.title) {
                EventsView(viewModel: EventsViewModel(calendar: viewModel.title, type: type))
            }
        }
        .listStyle(.inset)
        .navigationTitle(viewModel.title)
        .onAppear {
            Task {
                await viewModel.setup(networkManager: networkManager)
            }
        }
    }
}

#Preview {
    TypeView(viewModel: TypeViewModel(title: ""))
        .environmentObject(NetworkManager())
}
