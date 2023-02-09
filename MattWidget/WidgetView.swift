//
//  WidgetView.swift
//  Matt
//
//  Created by Jack Finnis on 07/02/2023.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
    enum State {
        case cartoon(Image)
        case away
        case loading
    }
    
    let state: State
    
    var body: some View {
        switch state {
        case .cartoon(let image):
            ZStack {
                Color.white
                image
                    .resizable()
                    .scaledToFit()
            }
        case .away:
            MattLogo(caption: " is away ")
        case .loading:
            ZStack {
                Color.white
                MattLogo(caption: "loading...")
            }
            .unredacted()
            .environment(\.colorScheme, .light)
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(state: .loading)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
