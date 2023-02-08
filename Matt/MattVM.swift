//
//  MattStorage.swift
//  Matt
//
//  Created by Jack Finnis on 08/02/2023.
//

import Foundation

@MainActor
class MattVM: ObservableObject {
    @Defaults("favourites") var favourites = [String]() { didSet {
        objectWillChange.send()
    }}
}
