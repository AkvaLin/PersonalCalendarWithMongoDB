//
//  RegisterView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @StateObject private var viewModel = RegisterViewModel()
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Group {
                TextField("Логин", text: $viewModel.login)
                HStack {
                    if viewModel.isSecure {
                        SecureField("Пароль", text: $viewModel.password)
                        
                    } else {
                        TextField("Пароль", text: $viewModel.password)
                    }
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.isSecure.toggle()
                        }
                    }, label: {
                        Image(systemName: !viewModel.isSecure ? "eye.slash" : "eye" )
                    })
                }
                HStack {
                    if viewModel.secondIsSecure {
                        SecureField("Пароль", text: $viewModel.secondPassword)
                        
                    } else {
                        TextField("Пароль", text: $viewModel.secondPassword)
                    }
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.secondIsSecure.toggle()
                        }
                    }, label: {
                        Image(systemName: !viewModel.secondIsSecure ? "eye.slash" : "eye" )
                    })
                }
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.bar))
            .padding(.bottom)
            Button {
                Task {
                    if await viewModel.register() {
                        isPresented.toggle()
                    }
                }
            } label: {
                Text("Зарегистрироваться")
                    .frame(maxWidth: .infinity)
            }
            .disabled(
                viewModel.login.isEmpty ||
                viewModel.password.isEmpty ||
                viewModel.secondPassword.isEmpty ||
                viewModel.password != viewModel.secondPassword
            )
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            viewModel.setup(networkManager: networkManager)
        }
    }
}

#Preview {
    RegisterView(isPresented: .constant(false))
        .environmentObject(NetworkManager())
}
