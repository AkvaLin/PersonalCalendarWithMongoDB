//
//  CalendarViewModel.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import Foundation

class CalendarViewModel: ObservableObject {
    
    @Published var calendars = [String]()
    @Published var results = [ItemModel]()
    @Published var isGridEnabled = false
    
    private var networkManager: NetworkManager? = nil
    
    public func setup(networkManager: NetworkManager) async {
        self.networkManager = networkManager
        do {
            let calendars = try await networkManager.getCalendars()
            DispatchQueue.main.async {
                self.calendars = calendars
            }
        } catch {
            
        }
    }
    
    public func doSearch() async {
        guard let networkManager = networkManager else { return }
        let data = await networkManager.group()
        DispatchQueue.main.async {
            self.results = data
        }
    }
}
