//
//  MyFolderApp.swift
//  MyFolder
//
//  Created by Peter Lizak on 13/01/2023.
//

import SwiftUI

@main
struct MyFolderApp: App {
    var body: some Scene {
        WindowGroup {
            VideoPlayerView(videoUrl: URL(string: "https://www.dropbox.com/s/df2d2gf1dvnr5uj/Sample_1280x720_mp4.mp4")!)
        }
    }
}
