//
//  MattStorage.swift
//  Matt
//
//  Created by Jack Finnis on 08/02/2023.
//

import Foundation

@MainActor
class MattVM: ObservableObject {
    @Published var fetch = false
    
    @Defaults("favourites") var favourites = [String]() { didSet {
        objectWillChange.send()
    }}
    var favouriteURLs: [URL] {
        favourites.compactMap(URL.init)
    }
}
