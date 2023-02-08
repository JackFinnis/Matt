//
//  WidgetView.swift
//  Matt
//
//  Created by Jack Finnis on 07/02/2023.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
    let image: Image?

    var body: some View {
        if let image {
            ZStack {
                Color.white
                image
                    .resizable()
                    .scaledToFit()
            }
        } else {
            MattIsAway()
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(image: nil)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
