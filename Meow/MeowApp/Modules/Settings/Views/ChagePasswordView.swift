//
//  ChagePasswordView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct ChagePasswordView: View {
    
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section {
                TextField("Пароль", text: $viewModel.password)
                TextField("Новый пароль", text: $viewModel.newPassword)
                TextField("Новый пароль", text: $viewModel.secondNewPassword)
            }
            Section {
                Button("Сменить", role: .none) {
                    Task {
                        await viewModel.changePassword()
                    }
                }
                .disabled(
                    viewModel.password != UserDefaults.standard.password ||
                    viewModel.newPassword.isEmpty ||
                    viewModel.newPassword != viewModel.secondNewPassword
                )
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Смена пароля")
        .toolbarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.password = ""
            viewModel.newPassword = ""
            viewModel.secondNewPassword = ""
        }
    }
}

#Preview {
    ChagePasswordView()
        .environmentObject(SettingsViewModel())
}
