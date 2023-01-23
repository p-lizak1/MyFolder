//
//  FolderItemView.swift
//  MyFolder
//
//  Created by Peter Lizak on 14/01/2023.
//

import SwiftUI

struct FolderItemView: View {

    // MARK: Lifecycle

    init(viewModel: FolderItemViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: viewModel.imageName)
                .font(.system(size: 30))
                .frame(width: 50, height: 50)

            VStack(alignment: .leading) {
                Text(viewModel.item.name)
                    .font(.system(size: 14))

                if let size = viewModel.item.size {
                    let fileSizeWithUnit = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
                    Text(String(fileSizeWithUnit))
                        .font(.system(size: 12))
                }
            }
            Spacer()
        }
    }

    // MARK: Private

    @ObservedObject private var viewModel: FolderItemViewModel

}

struct FolderItemView_Previews: PreviewProvider {
    static var previews: some View {
        FolderItemView(viewModel: FolderItemViewModel(
            item: Item(id: "", isDir: false, name: "File 1", parentID: nil, contentType: "image/jpeg", size: nil, children: nil)))
    }
}
