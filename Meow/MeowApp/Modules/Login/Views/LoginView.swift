//
//  LoginView.swift
//  MeowApp
//
//  Created by Никита Пивоваров on 05.11.2023.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var networkManager: NetworkManager
    @Binding var isPresented: Bool
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
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
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.bar))
                .padding(.bottom)
                Button {
                    Task {
                        if await networkManager.checkLogin(login: viewModel.login, password: viewModel.password) {
                            DispatchQueue.main.async {
                                isPresented.toggle()
                            }
                        }
                    }
                } label: {
                    Text("Войти")
                        .frame(maxWidth: .infinity)
                }
                .disabled(
                    viewModel.login.isEmpty ||
                    viewModel.password.isEmpty
                )
                .buttonStyle(.borderedProminent)
                NavigationLink("Зарегестрироваться") {
                    RegisterView(isPresented: $isPresented)
                }
                .padding(.top)
            }
            .padding()
        }
    }
}

#Preview {
    LoginView(isPresented: .constant(true))
}
