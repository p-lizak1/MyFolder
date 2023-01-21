//
//  MyFolderApp.swift
//  MyFolder
//
//  Created by Peter Lizak on 13/01/2023.
//

import SwiftUI

@main
struct MyFolderApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel())
        }
    }
}
