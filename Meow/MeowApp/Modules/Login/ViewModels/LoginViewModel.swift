//
//  LoginViewModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var login = ""
    @Published var password = ""
    @Published var isSecure = true
    
}
