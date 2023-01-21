//
//  Session.swift
//  MyFolder
//
//  Created by Peter Lizak on 19/01/2023.
//

import Foundation

protocol SessionStoring {
    var credentials: Credentials { get }
    func setSessionFor(credentials: Credentials)
}

class SessionStorage: SessionStoring {

    // MARK: Internal

    static let shared: SessionStorage = SessionStorage()

    var credentials: Credentials {
        storedCredentials
    }

    func setSessionFor(credentials: Credentials) {
        storedCredentials.username = credentials.username
        storedCredentials.password = credentials.password
    }

    // MARK: Private

    private var storedCredentials: Credentials = Credentials(username: "", password: "")
}
