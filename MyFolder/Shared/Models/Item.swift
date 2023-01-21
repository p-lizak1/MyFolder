//
//  Item.swift
//  MyFolder
//
//  Created by Peter Lizak on 18/01/2023.
//

import Foundation

struct Folder {
    var id: String
    var parentID: String?
    var items: [Item]
    var isRootFolder = false
}

struct Item: Codable, Identifiable {
    let id: String
    let isDir: Bool
    let name: String
    var parentID: String?
    let contentType: String?
    let size: Int?
    var children: [String]?
    var modificationDate: String?

    // MARK: - Computed properties

    var group: ItemGroup {
        if isDir { return .folder }
        if contentType == "image/jpeg" { return .image }
        return .unknown
    }
}

enum ItemGroup {
    case folder
    case image
    case text
    case unknown
}
