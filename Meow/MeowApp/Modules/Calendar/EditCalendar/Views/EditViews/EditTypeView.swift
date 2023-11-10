//
//  EditTypeView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import SwiftUI

struct EditTypeView: View {
    
    public let type: TypeModel
    @EnvironmentObject var networkManager: NetworkManager
    @State var newTitle = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Новый тип", text: $newTitle)
            }
            Section {
                Button("Обновить") {
                    Task {
                        do {
                            try await networkManager.updateType(type: type, title: newTitle)
                        } catch {
                            
                        }
                        DispatchQueue.main.async {
                            newTitle = ""
                        }
                    }
                }
                .disabled(
                    newTitle.isEmpty
                )
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(type.title)
        .toolbarTitleDisplayMode(.inline)
    }
}
