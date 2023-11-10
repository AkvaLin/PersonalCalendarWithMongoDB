//
//  TypeViewModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import Foundation

class TypeViewModel: ObservableObject {
    public let title: String
    @Published var types = [TypeModel]()
    private var networkManager: NetworkManager? = nil
    
    init(title: String) {
        self.title = title
    }
    
    public func setup(networkManager: NetworkManager) async {
        self.networkManager = networkManager
        do {
            let types = try await networkManager.getTypes(for: title)
            DispatchQueue.main.async {
                self.types = types
            }
        } catch {
            
        }
    }
}
