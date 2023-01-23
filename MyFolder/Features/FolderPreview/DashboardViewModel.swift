//
//  DashboardViewModel.swift
//  MyFolder
//
//  Created by Peter Lizak on 14/01/2023.
//

import PhotosUI
import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {

    // MARK: Lifecycle

    init(user: User, networkService: NetworkServicing = NetworkService(), storage: FolderDataStorage = FolderDataStorage()) {
        self.networkService = networkService
        self.user = user
        folderStorage = storage

        let rootItem = user.rootItem
        insertFolderFor(id: rootFolderID, parentID: nil, with: [rootItem], isRootFolder: true)
        changeLoadingStateTo(state: .loaded)
    }

    // MARK: Internal

    enum LoadingState {
        case idle
        case loading
        case failed
        case loaded
    }

    var user: User
    @Published var folderName: String = ""
    @Published var presentCreateDirAlert = false
    /// When the item is set, a modal preview will open up showing the image
    @Published var imageItemToShow: Item?
    @Published var shouldShowPhotoPicker: Bool = false
    /// Determines if the action buttons, back and add new content, is visible
    @Published var showActions: Bool = false
    /// Determines if the action buttons, back and add new content, is visible
    @Published var actionMenuIsVisible: Bool = false
    @Published var selectedImage: UIImage = UIImage()
    @Published private(set) var loadingState: LoadingState = .loaded

    /// The curent folder which is displayed,
    @Published var folderToDisplay: Folder = Folder(id: "", parentID: nil, items: []) {
        didSet {
            actionMenuIsVisible = !folderToDisplay.isRootFolder
        }
    }

    func handleTapOn(item: Item) async {
        if item.group == .folder {
            await loadDirFor(id: item.id)
        } else if item.group == .image {
            imageItemToShow = item
        }
    }

    func dirUp() {
        folderStorage.deleteFolderFor(id: folderToDisplay.parentID)
        changeLoadingStateTo(state: .loading)
        getParentFolderFor(id: folderToDisplay.parentID)
        changeLoadingStateTo(state: .loaded)
    }

    func createFolderTapped() {
        presentCreateDirAlert = true
    }

    func didConfirmCreatingFolder() async {
        guard let currentDirParentID = folderToDisplay.parentID else { return }
        let result = await networkService.load(
            resource:
            Resources.Folder.createFolderFor(
                for: currentDirParentID,
                folderName: NewFolderRequest(name: folderName)))
        switch result {
        case let .success(createdItem):
            insertItemToCurrentFolder(item: createdItem)
        case let .failure(error):
            print("Error happend \(error)")
        }
    }

    func delete(item: Item) async {
        await deleteItemFor(id: item.id)
    }

    func uploadItemFor(image: UIImage) async {
        if let data = image.jpegData(compressionQuality: 1.0) {
            await uploadImageFor(data: data)
        }
    }

    // MARK: Private

    private let rootFolderID = UUID().uuidString
    private var folderStorage: FolderDataStorage
    private let networkService: NetworkServicing

    private func uploadImageFor(data: Data) async {
        let imageName = "image_\(Int.random(in: 1 ... 999_999))"
        guard let currentDirParentID = folderToDisplay.parentID else { return }
        let result = await networkService.load(
            resource:
            Resources.uploadImage(for: data, toFolder: currentDirParentID, withName: imageName))
        if case let .success(createdItem) = result {
            insertItemToCurrentFolder(item: createdItem)
        }
    }

    private func insertItemToCurrentFolder(item: Item) {
        folderStorage.insert(item: item, toFolder: folderToDisplay.id)
        syncCurrentFolderWithStorage()
    }

    private func deleteItemFor(id: String) async {
        changeLoadingStateTo(state: .loading)
        _ = await networkService.loadVoid(resource: Resources.Folder.deleteItem(for: id))
        folderStorage.deleteItemFor(id: id)
        syncCurrentFolderWithStorage()
        changeLoadingStateTo(state: .loaded)
    }

    private func getParentFolderFor(id: String?) {
        if let safeID = id, let folder = folderStorage.getParentFolderOfFolder(with: safeID) {
            folderToDisplay = folder
        }
    }

    private func disPlayFolderFor(id: String?) {
        if let safeID = id, let folder = folderStorage.getFolderFor(id: safeID) {
            folderToDisplay = folder
        }
    }

    private func changeLoadingStateTo(state: LoadingState) {
        loadingState = state
    }

    private func loadDirFor(id: String) async {
        changeLoadingStateTo(state: .loading)

        let result = await networkService.load(resource: Resources.Folder.getDirectoryContentFor(id: id))
        switch result {
        case let .success(directoryContent):
            let newDirectoryID = UUID().uuidString
            insertFolderFor(id: newDirectoryID, parentID: id, with: directoryContent)
            changeLoadingStateTo(state: .loaded)
        case .failure:
            changeLoadingStateTo(state: .failed)
        }
    }

    private func insertFolderFor(id: String, parentID: String?, with content: [Item], isRootFolder: Bool = false) {
        var mutableContent = content
        mutableContent.indices.forEach { mutableContent[$0].parentID = id }
        folderStorage.append(id: id, parentID: parentID, items: mutableContent, isRootFolder: isRootFolder)
        disPlayFolderFor(id: id)
    }

    private func syncCurrentFolderWithStorage() {
        if let folder = folderStorage.getFolderFor(id: folderToDisplay.id) {
            folderToDisplay = folder
        }
    }
}
