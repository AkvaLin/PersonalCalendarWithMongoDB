//
//  SettingsView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var networkManager: NetworkManager
    @Binding var isLoginViewPresented: Bool
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Сменить логин") {
                        ChangeLoginView()
                            .environmentObject(viewModel)
                    }
                    NavigationLink("Сменить пароль") {
                        ChagePasswordView()
                            .environmentObject(viewModel)
                    }
                }
                Section {
                    Button("Выйти") {
                        UserDefaults.standard.login = ""
                        UserDefaults.standard.password = ""
                        isLoginViewPresented.toggle()
                    }
                    Button("Удалить аккаунт") {
                        Task {
                            await viewModel.deleteAccount()
                            DispatchQueue.main.async {
                                isLoginViewPresented.toggle()
                            }
                        }
                    }
                    .tint(.red)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("Настройки")
        }
        .onAppear {
            viewModel.setup(networkManager: networkManager)
        }
    }
}

#Preview {
    SettingsView(isLoginViewPresented: .constant(false))
        .environmentObject(NetworkManager())
}
