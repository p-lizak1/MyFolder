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
            MockFactory.generateImageItem(),
            MockFactory.generateFolderItem(),
            MockFactory.generateImageItem(),
            MockFactory.generateFolderItem()
        ]
        FolderView(viewModel: FolderViewModel(items: items, itemClicked: { _ in
            // Mock do nothing
        }, onDeleteItem: { _ in
            // Mock do nothing
        }))
    }
}
