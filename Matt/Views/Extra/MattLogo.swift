//
//  MattLogo.swift
//  Matt
//
//  Created by Jack Finnis on 09/02/2023.
//

import SwiftUI

struct MattLogo: View {
    let caption: String
    
    var body: some View {
        VStack {
            Image("matt")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
            Text(caption)
                .font(.system(.title3, design: .serif).italic())
                .blur(radius: 0.25)
                .opacity(0.8)
        }
        .allowsHitTesting(false)
    }
}
