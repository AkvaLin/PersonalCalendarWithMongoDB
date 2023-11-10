//
//  ChangeLoginView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct ChangeLoginView: View {
    
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section {
                TextField("Новый логин", text: $viewModel.newLogin)
            }
            Section {
                Button("Сменить", role: .none) {
                    Task {
                        await viewModel.changeLogin()
                    }
                }
                .disabled(
                    viewModel.newLogin.isEmpty
                )
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Смена логина")
        .toolbarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.newLogin = ""
        }
    }
}

#Preview {
    ChangeLoginView()
        .environmentObject(SettingsViewModel())
}
