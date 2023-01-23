//
//  LoginViewModel.swift
//  MyFolder
//
//  Created by Peter Lizak on 19/01/2023.
//

import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {

    // MARK: Lifecycle

    init(networkService: NetworkServicing = NetworkService()) {
        self.networkService = networkService
    }

    // MARK: Internal

    @Published var credentials: Credentials = Credentials(username: "", password: "")
    @Published var user: User?
    @Published var userDidLogin = false

    let networkService: NetworkServicing

    func loginUser() async {
        await authenticate()
    }

    // MARK: Private

    private func authenticate() async {
        SessionStorage.shared.setSessionFor(credentials: credentials)
        let result = await networkService.load(resource: Resources.Folder.getMe())
        switch result {
        case let .success(user):
            self.user = user
            userDidLogin = true
        case .failure:
            print("Handle error")
        }
    }

}
