//
//  LoginView.swift
//  MyFolder
//
//  Created by Peter Lizak on 19/01/2023.
//

import SwiftUI

struct LoginView: View {

    // MARK: Lifecycle

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    @ObservedObject var viewModel: LoginViewModel
    @State var loginTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Email", text: $viewModel.credentials.username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .shadow(radius: 5.0)

                SecureField("Password", text: $viewModel.credentials.password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .shadow(radius: 5.0)

                Button(action: {
                    loginTask = Task {
                        await viewModel.loginUser()
                    }
                }, label: {
                    Text("Log in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.lightBlue)
                        .cornerRadius(5.0)
                })

                Button(action: {
                    loginTask = Task {
                        viewModel.credentials = Credentials(username: "noel", password: "foobar")
                        await viewModel.loginUser()
                    }
                }, label: {
                    Text("Fast login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.lightBlue)
                        .cornerRadius(5.0)
                })
            }
            .padding()
            .navigationTitle("Login")
            .navigationDestination(isPresented: $viewModel.userDidLogin) {
                if let user = viewModel.user {
                    DashboardView(viewModel: DashboardViewModel(user: user, networkService: viewModel.networkService))
                }
            }
            .onDisappear {
                loginTask?.cancel()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
