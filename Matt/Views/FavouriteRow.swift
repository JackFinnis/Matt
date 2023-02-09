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
    
    let url: URL
    
    var body: some View {
        if let cartoon {
            Image(uiImage: cartoon.uiImage)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, -30)
                .listRowBackground(Color.white)
                .shareCartoon(cartoon: cartoon, isPresented: $showShareSheet)
                .contextMenu {
                    Button {
                        showShareSheet = true
                    } label: {
                        Label("Share...", systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive) {
                        mattVM.favourites.removeAll { $0 == url.absoluteString }
                    } label: {
                        Label("Unfavourite", systemImage: "star.slash")
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
