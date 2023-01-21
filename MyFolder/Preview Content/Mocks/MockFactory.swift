//
//  UserFactoryMock.swift
//  MyFolder
//
//  Created by Peter Lizak on 19/01/2023.
//

import Foundation

class MockFactory {
    static func generateUser() -> User {
        User(
            firstName: "Noel",
            lastName: "Foobar",
            rootItem: Item(id: "rootItemID", isDir: true, name: "image1", contentType: nil, size: nil))
    }

    static func generateItem() -> Item {
        Item(id: UUID().uuidString, isDir: true, name: "MockItem\(UUID().uuidString)", contentType: nil, size: nil)
    }

    static func generateImageItem() -> Item {
        Item(id: UUID().uuidString, isDir: false, name: "MockItem\(UUID().uuidString)", contentType: "image/jpeg", size: nil)
    }

    static func generateFolderItem() -> Item {
        Item(id: UUID().uuidString, isDir: true, name: "MockItem\(UUID().uuidString)", contentType: nil, size: nil)
    }
}
