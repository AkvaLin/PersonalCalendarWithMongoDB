//
//  UserDefaultsExtensions.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import Foundation
import BSON

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case login
        case password
        case id
    }
    
    var login: String {
        get {
            string(forKey: UserDefaultsKeys.login.rawValue) ?? ""
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.login.rawValue)
        }
    }
    
    var password: String {
        get {
            string(forKey: UserDefaultsKeys.password.rawValue) ?? ""
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.password.rawValue)
        }
    }
    
    var id: String {
        get {
            string(forKey: UserDefaultsKeys.id.rawValue) ?? ""
        }
        set {
            setValue(newValue,
                     forKey: UserDefaultsKeys.id.rawValue)
        }
    }
}
