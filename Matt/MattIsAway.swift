//
//  MattIsAway.swift
//  Matt
//
//  Created by Jack Finnis on 13/01/2023.
//

import SwiftUI

struct MattIsAway: View {
    var body: some View {
        VStack {
            Image("matt")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
            Text("is away")
                .font(.system(.title3, design: .serif).italic())
        }
        .allowsHitTesting(false)
    }
}

struct MattIsAway_Previews: PreviewProvider {
    static var previews: some View {
        MattIsAway()
    }
}
