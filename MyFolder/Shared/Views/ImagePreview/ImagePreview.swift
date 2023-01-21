//
//  ImagePreview.swift
//  MyFolder
//
//  Created by Peter Lizak on 17/01/2023.
//

import Combine
import SwiftUI
import UIKit

@MainActor
struct ImagePreview: View {

    // MARK: Lifecycle

    init(item: Item) {
        self.item = item
    }

    // MARK: Internal

    @State var image: UIImage?

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                LoadingView()
            }
        }
        .onAppear {
            Task {
                try await loadImage()
            }
        }
    }

    // MARK: Private

    private let item: Item
    private let networkService: NetworkServicing = NetworkService()

    private func loadImage() async throws {
        let data = await networkService.loadDataFrom(resource: Resources.Folder.loadImage(for: item.id))
        if case let .success(data) = data {
            image = UIImage(data: data)
        }
        // Handle network failure
    }
}
