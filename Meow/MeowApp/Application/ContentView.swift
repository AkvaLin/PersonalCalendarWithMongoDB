//
//  ContentView.swift
//  Meow
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var networkManager = NetworkManager()
    @State private var isLoginViewPresented = false
    @State private var selection = 2
    
    var body: some View {
        TabView(selection: $selection) {
            EditView()
                .environmentObject(networkManager)
                .tabItem {
                    Label(
                        title: { Text("Изменить") },
                        icon: { Image(systemName: "pencil") }
                    )
                }
                .tag(1)
            CalendarView()
                .environmentObject(networkManager)
                .tabItem {
                    Label(
                        title: { Text("Календарь") },
                        icon: { Image(systemName: "calendar") }
                    )
                }
                .tag(2)
            SettingsView(isLoginViewPresented: $isLoginViewPresented)
                .environmentObject(networkManager)
                .tabItem {
                    Label(
                        title: { Text("Настройки") },
                        icon: { Image(systemName: "gear") }
                    )
                }
                .tag(3)
        }
        .onAppear {
            if UserDefaults.standard.login.isEmpty {
                isLoginViewPresented = true
            }
            Task {
                await networkManager.onAppear()
            }
        }
        .fullScreenCover(isPresented: $isLoginViewPresented, content: {
            LoginView(isPresented: $isLoginViewPresented)
                .environmentObject(networkManager)
        })
    }
}

#Preview {
    ContentView()
}
