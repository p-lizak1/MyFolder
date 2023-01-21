//
//  LoginViewModelTests.swift
//  MyFolderTests
//
//  Created by Peter Lizak on 19/01/2023.
//

import XCTest
@testable import MyFolder

@MainActor
final class LoginViewModelTests: XCTestCase {

    var loginViewModel: LoginViewModel!
    var user: User!

    @MainActor
    override func setUpWithError() throws {
        user = MockFactory.generateUser()
        let jsonData = try JSONEncoder().encode(user)
        loginViewModel = LoginViewModel(networkService: NetworkingServiceMock(returnData: jsonData))
    }

    func testLogin() async throws {
        await loginViewModel.loginUser()
        XCTAssertTrue(loginViewModel.userDidLogin)
        XCTAssertEqual(loginViewModel.user!.firstName, user.firstName)
        XCTAssertEqual(loginViewModel.user!.lastName, user.lastName)
        XCTAssertEqual(loginViewModel.user!.rootItem.id, user.rootItem.id)
    }
}
