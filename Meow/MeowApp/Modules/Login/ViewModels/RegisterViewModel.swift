//
//  RegisterViewModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import Foundation
import MongoKitten

class RegisterViewModel: ObservableObject {
    @Published var login = ""
    @Published var password = ""
    @Published var secondPassword = ""
    @Published var isSecure = true
    @Published var secondIsSecure = true
    @Published var showLoginError = false
    @Published var showError = false
    
    private var networkManager: NetworkManager? = nil

    public func setup(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    public func register() async -> Bool {
        guard let networkManager = networkManager else {
            showError = true
            return false
        }
        do {
            let result = try await networkManager.register(login: login, password: password)
            if result {
                UserDefaults.standard.login = login
                UserDefaults.standard.password = password
            } else {
                showError = true
            }
            return result
        } catch {
            DispatchQueue.main.async {
                self.showLoginError = true
            }
            return false
        }
    }
}
