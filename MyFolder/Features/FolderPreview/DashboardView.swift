//
//  ContentView.swift
//  MyFolder
//
//  Created by Peter Lizak on 13/01/2023.
//

import PhotosUI
import SwiftUI

struct DashboardView: View {

    // MARK: Lifecycle

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    @ObservedObject var viewModel: DashboardViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.loadingState == .loaded {
                ZStack(alignment: .bottom) {
                    if $viewModel.folderToDisplay.items.isEmpty {
                        VStack {
                            Text("Folder is empty")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        folderView
                    }

                    if viewModel.actionMenuIsVisible {
                        bottomMenuView
                    }
                }
            } else if viewModel.loadingState == .failed {
                Text("Something is not right. Please retry or check your internet connection")
            } else if viewModel.loadingState == .loading {
                LoadingView()
            }

        }
        .navigationTitle("Welcome \(viewModel.user.firstName)")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .sheet(item: $viewModel.imageItemToShow, onDismiss: {
            viewModel.imageItemToShow = nil
        }) { item in
            ImagePreview(item: item)
        }

        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedImage)
        }
        .onChange(of: viewModel.selectedImage) { newValue in
            Task {
                await viewModel.uploadItemFor(image: newValue)
            }
        }

        .alert("Create new folder", isPresented: $viewModel.presentCreateDirAlert, actions: {
            TextField("Folder name", text: $viewModel.folderName)
            Button("Create", action: {
                Task {
                    await viewModel.didConfirmCreatingFolder()
                }
            })
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Please enter your new directory name.")
        })
    }

    // MARK: Private

    @State private var showSheet = false
}

extension DashboardView {
    var folderView: some View {
        FolderView(viewModel: FolderViewModel(items: viewModel.folderToDisplay.items, itemClicked: { item in
            Task {
                await viewModel.handleTapOn(item: item)
            }
        }, onDeleteItem: { item in
            Task {
                await viewModel.delete(item: item)
            }
        }))
    }

    var bottomMenuView: some View {
        HStack {
            if viewModel.actionMenuIsVisible {
                Button(action: {
                    viewModel.dirUp()
                }, label: {
                    Image(systemName: "arrow.backward")
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.lightGray)
                        .clipShape(Circle())
                })
                .padding(.leading, 10)

                Spacer()

                Button(action: {
                    viewModel.showActions = true
                }, label: {
                    Image(systemName: "plus")
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.lightBlue)
                        .clipShape(Circle())
                })
                .padding(.trailing, 10)
                .confirmationDialog("Pick your action", isPresented: $viewModel.showActions, titleVisibility: .visible) {
                    Button("Add folder") {
                        viewModel.createFolderTapped()
                    }

                    Button("Add photo") {
                        showSheet = true
                        viewModel.shouldShowPhotoPicker = true
                    }
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(viewModel: DashboardViewModel(user: MockFactory.generateUser()))
    }
}
