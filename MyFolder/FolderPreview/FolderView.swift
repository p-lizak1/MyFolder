//
//  FolderView.swift
//  MyFolder
//
//  Created by Peter Lizak on 14/01/2023.
//

import SwiftUI

struct FolderView: View {

    // MARK: Lifecycle

    init(viewModel: FolderViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    @ObservedObject var viewModel: FolderViewModel

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                FolderItemView(viewModel: FolderItemViewModel(item: item))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.itemClicked(item)
                    }
                    .onLongPressGesture {
                        viewModel.presentDeleteAlert = true
                        viewModel.pendingValueToDelete = item
                    }
            }
        }

        .alert("Deleting the item", isPresented: $viewModel.presentDeleteAlert, actions: {
            Button("Delete", action: {
                viewModel.deletePendingItem()
            })
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Do you rellay want to delete the item?")
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        let items = [
            Item(id: "id1", isDir: false, name: "File 1", parentID: nil, contentType: "image/jpeg", size: nil, children: nil),
            Item(id: "id2", isDir: true, name: "Folder 1", parentID: nil, contentType: nil, size: nil, children: nil),
            Item(id: "id3", isDir: true, name: "Folder 2", parentID: nil, contentType: nil, size: nil, children: nil),
            Item(id: "id4", isDir: false, name: "File 2", parentID: nil, contentType: "image/jpeg", size: nil, children: nil)
        ]
        FolderView(viewModel: FolderViewModel(items: items, itemClicked: { _ in
            // Mock do nothing
        }, onDeleteItem: { _ in
            // Mock do nothing
        }))
    }
}
