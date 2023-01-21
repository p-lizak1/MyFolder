//
//  LoadingView.swift
//  MyFolder
//
//  Created by Peter Lizak on 19/01/2023.
//

import SwiftUI

// I took the opportunity and asked ChatGPT for a nice loading indicator
// This is the outcome:
struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .padding()
                .foregroundColor(Color.blue)
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))

            Text("Loading...")
                .foregroundColor(Color.blue)
        }
    }
}
