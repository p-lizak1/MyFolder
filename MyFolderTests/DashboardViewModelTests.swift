//
//  DashboardViewModelTests.swift
//  MyFolderTests
//
//  Created by Peter Lizak on 19/01/2023.
//

import _PhotosUI_SwiftUI
import PhotosUI
import XCTest
@testable import MyFolder

// swiftlint:disable force_cast
@MainActor
final class DashboardViewModelTests: XCTestCase {

    // MARK: Internal

    var dashboardViewModel: DashboardViewModel!
    var user: User!
    var networkingService: NetworkServicing!
    var mockedItems: [Item] = []

    @MainActor
    override func setUpWithError() throws {
        user = MockFactory.generateUser()
        let jsonData = try JSONEncoder().encode(user)
        networkingService = NetworkingServiceMock(returnData: jsonData)
        dashboardViewModel = DashboardViewModel(user: user, networkService: networkingService)
    }

    override func tearDownWithError() throws {
        dashboardViewModel = nil
        user = nil
        networkingService = nil
        mockedItems = []
    }

    func testInitialState() {
        XCTAssertNil(dashboardViewModel.folderToDisplay.parentID)
        XCTAssertTrue(dashboardViewModel.folderToDisplay.isRootFolder)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items.first!.id, user.rootItem.id)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items.first!.name, user.rootItem.name)
        XCTAssertFalse(dashboardViewModel.actionMenuIsVisible)
    }

    func testTapOnFolder() async throws {
        let item1 = MockFactory.generateItem()
        let item2 = MockFactory.generateItem()
        let newItems: [Item] = [item1, item2]
        let jsonData = try JSONEncoder().encode(newItems)
        (networkingService as! NetworkingServiceMock).returnData = jsonData
        await dashboardViewModel.handleTapOn(item: dashboardViewModel.user.rootItem)

        XCTAssertEqual(dashboardViewModel.folderToDisplay.items[0].name, item1.name)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items[0].id, item1.id)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items[1].name, item2.name)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items[1].id, item2.id)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.isRootFolder, false)

        XCTAssertTrue(dashboardViewModel.actionMenuIsVisible)
    }

    func testDirUp() async throws {
        try await mockGoingToFolderWithTwoItems()

        dashboardViewModel.dirUp()
        XCTAssertEqual(dashboardViewModel.folderToDisplay.isRootFolder, true)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items[0].id, user.rootItem.id)
    }

    func testAddImage() async throws {
        try await mockGoingToFolderWithTwoItems()

        let imageItem = MockFactory.generateImageItem()
        let jsonImageData = try JSONEncoder().encode(imageItem)
        (networkingService as! NetworkingServiceMock).returnData = jsonImageData

        await dashboardViewModel.uploadItemFor(image: UIImage(systemName: "square.and.arrow.up.circle.fill")!)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items.count, 3)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items[2].group, .image)
    }

    func testCreateFolder() async throws {
        try await mockGoingToFolderWithTwoItems()

        let folderItem = MockFactory.generateFolderItem()
        let folderItemData = try JSONEncoder().encode(folderItem)
        (networkingService as! NetworkingServiceMock).returnData = folderItemData

        dashboardViewModel.folderName = "TestFolder1"

        await dashboardViewModel.didConfirmCreatingFolder()
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items.count, 3)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items[2].group, .folder)
    }

    func testDeletingItems() async throws {
        try await mockGoingToFolderWithTwoItems()

        let folderItem = MockFactory.generateFolderItem()
        let folderItemData = try JSONEncoder().encode(folderItem)
        (networkingService as! NetworkingServiceMock).returnData = folderItemData

        dashboardViewModel.folderName = "TestFolder1"
        await dashboardViewModel.didConfirmCreatingFolder()

        let items = mockedItems

        XCTAssertEqual(dashboardViewModel.folderToDisplay.items.count, 3)
        await dashboardViewModel.delete(item: items[0])
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items.count, 2)
        await dashboardViewModel.delete(item: items[1])
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items.count, 1)
        await dashboardViewModel.delete(item: folderItem)
        XCTAssertEqual(dashboardViewModel.folderToDisplay.items.count, 0)
    }

    // MARK: Private

    private func mockGoingToFolderWithTwoItems() async throws {
        let item1 = MockFactory.generateItem()
        let item2 = MockFactory.generateItem()
        let newItems: [Item] = [item1, item2]
        mockedItems = newItems
        let jsonData = try JSONEncoder().encode(newItems)
        (networkingService as! NetworkingServiceMock).returnData = jsonData
        await dashboardViewModel.handleTapOn(item: dashboardViewModel.user.rootItem)
    }
}
