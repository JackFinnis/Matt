//
//  FavouriteRow.swift
//  Matt
//
//  Created by Jack Finnis on 09/02/2023.
//

import SwiftUI

struct FavouriteRow: View {
    @ObservedObject var mattVM: MattVM
    @State var cartoon: Cartoon?
    @State var showShareSheet = false
    @State var showDeleteConfirmation = false
    
    let url: URL
    
    var body: some View {
        if let cartoon {
            Image(uiImage: cartoon.uiImage)
                .resizable()
                .scaledToFill()
                .cornerRadius(20)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .shareCartoon(cartoon: cartoon, isPresented: $showShareSheet)
                .contextMenu {
                    Button {
                        showShareSheet = true
                    } label: {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Unfavourite", systemImage: "star.slash")
                    }
                }
                .swipeActions(allowsFullSwipe: false) {
                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "star.slash", fontSize: 20, tint: .red)
                    }
                    .tint(.clear)
                    
                    Button {
                        showShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up", fontSize: 20, tint: .accentColor)
                    }
                    .tint(.clear)
                }
                .confirmationDialog("Remove this cartoon from your favourites?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                    Button("Remove", role: .destructive) {
                        mattVM.favourites.removeAll { $0 == url.absoluteString }
                        Haptics.tap()
                    }
                }
        } else {
            ProgressView().task {
                await fetch()
            }
            .onChange(of: mattVM.fetch) { _ in
                Task {
                    await fetch()
                }
            }
        }
    }
    
    func fetch() async {
        if let uiImage = await UIImage(loadFrom: url) {
            cartoon = Cartoon(uiImage: uiImage, url: url)
        }
    }
}

struct FavouriteRow_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteRow(mattVM: MattVM(), url: URL(string: "https://www.telegraph.co.uk/content/dam/PortalPictures/january-23/0902-MATT-PORTAL-WEB-P1.png")!)
    }
}
