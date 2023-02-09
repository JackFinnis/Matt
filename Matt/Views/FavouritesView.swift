//
//  FavouritesView.swift
//  Matt
//
//  Created by Jack Finnis on 09/02/2023.
//

import SwiftUI

struct FavouritesView: View {
    @ObservedObject var mattVM: MattVM
    
    var body: some View {
        List(mattVM.favouriteURLs, id: \.self) { url in
            Section {
                FavouriteRow(mattVM: mattVM, url: url)
            }
        }
        .animation(.default, value: mattVM.favourites)
        .navigationTitle("Favourites")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            mattVM.fetch.toggle()
        }
        .overlay {
            if mattVM.favouriteURLs.isEmpty {
                ErrorLabel(systemName: "star", tint: .yellow, title: "No Favourites Yet", message: "Tap on the yellow star at the top right of the home screen to save your favourite cartoons!")
                    .padding()
            }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView(mattVM: MattVM())
    }
}
