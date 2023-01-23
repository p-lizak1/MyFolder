//
//  ItemViewModel.swift
//  MyFolder
//
//  Created by Peter Lizak on 17/01/2023.
//

import Foundation

@MainActor
class FolderItemViewModel: ObservableObject {

    // MARK: Lifecycle

    init(item: Item) {
        self.item = item
    }

    // MARK: Internal

    @Published var item: Item

    var imageName: String {
        if item.group == .folder {
            return "folder.fill"
        } else if item.group == .image {
            return "photo"
        } else if item.group == .text {
            return "doc.text.fill"
        } else {
            return "doc.fill"
        }
    }
}
