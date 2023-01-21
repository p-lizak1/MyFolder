//
//  FolderViewModel.swift
//  MyFolder
//
//  Created by Peter Lizak on 14/01/2023.
//

import SwiftUI

@MainActor
class FolderViewModel: ObservableObject {

    // MARK: Lifecycle

    init(items: [Item] = [], itemClicked: @escaping (Item) -> Void, onDeleteItem: @escaping (Item) -> Void) {
        self.items = items
        self.itemClicked = itemClicked
        self.onDeleteItem = onDeleteItem
    }

    // MARK: Internal

    var pendingValueToDelete: Item?
    var items: [Item]
    let itemClicked: (Item) -> Void
    let onDeleteItem: (Item) -> Void
    @Published var presentDeleteAlert = false

    func deletePendingItem() {
        if let item = pendingValueToDelete {
            onDeleteItem(item)
            pendingValueToDelete = nil
        }
    }
}
