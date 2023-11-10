//
//  EventView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 06.11.2023.
//

import SwiftUI

struct EventView: View {
    
    let model: EventModel
    
    init(model: EventModel) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Text(model.details.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            Text(Date(timeIntervalSince1970: model.details.date).formatted())
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .trailing)
            Text("Гости:")
            ForEach(model.details.guests, id: \.self) { guest in
                Text(guest)
            }
        }
        .padding()
        .navigationTitle(model.title)
    }
}
