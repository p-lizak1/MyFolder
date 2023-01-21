//
//  FolderStorage.swift
//  MyFolder
//
//  Created by Peter Lizak on 19/01/2023.
//

import Foundation

class FolderDataStorage {

    // MARK: Internal

    func insert(item: Item, toFolder id: String?) {
        if let index = itemsStorage.firstIndex(where: { $0.id == id }) {
            itemsStorage[index].items.append(item)
        }
    }

    func deleteItemFor(id: String) {
        if let index = itemsStorage.firstIndex(where: { $0.items.contains(where: { $0.id == id }) }) {
            itemsStorage[index].items = itemsStorage[index].items.filter { $0.id != id }
        }
    }

    func append(id: String = UUID().uuidString, parentID: String?, items: [Item], isRootFolder: Bool = false) {
        itemsStorage.append(Folder(id: id, parentID: parentID, items: items, isRootFolder: isRootFolder))
    }

    func getFolderFor(id: String?) -> Folder? {
        itemsStorage.first(where: { $0.id == id })
    }

    func deleteFolderFor(id: String?) {
        itemsStorage = itemsStorage.filter({ $0.id != id })
    }

    func getParentFolderOfFolder(with id: String) -> Folder? {
        itemsStorage.first(where: { $0.items.contains(where: { $0.id == id }) })
    }

    // MARK: Private

    private var itemsStorage: [Folder] = []
}
