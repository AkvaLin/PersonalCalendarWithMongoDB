//
//  SettingsViewModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var newLogin = ""
    @Published var password = ""
    @Published var newPassword = ""
    @Published var secondNewPassword = ""
    private var networkManager: NetworkManager? = nil

    public func setup(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    public func changeLogin() async {
        guard let networkManager = networkManager else { return }
        do {
            let result = try await networkManager.changeLogin(login: UserDefaults.standard.login, newLogin: newLogin)
            if result {
                UserDefaults.standard.login = newLogin
            }
            DispatchQueue.main.async {
                self.newLogin = ""
            }
        } catch {
            DispatchQueue.main.async {
                self.newLogin = ""
            }
        }
    }
    
    public func changePassword() async {
        guard let networkManager = networkManager else { return }
        do {
            try await networkManager.changePassword(login: UserDefaults.standard.login, password: newPassword)
            UserDefaults.standard.password = newPassword
            DispatchQueue.main.async {
                self.password = ""
                self.newPassword = ""
                self.secondNewPassword = ""
            }
        } catch {
            DispatchQueue.main.async {
                self.password = ""
                self.newPassword = ""
                self.secondNewPassword = ""
            }
        }
    }
    
    public func deleteAccount() async {
        guard let networkManager = networkManager else { return }
        do {
            try await networkManager.deleteAll()
        } catch {
            
        }
    }
    
}
