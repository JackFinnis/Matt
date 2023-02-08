//
//  MattWidgetBundle.swift
//  MattWidget
//
//  Created by Jack Finnis on 13/01/2023.
//

import WidgetKit
import SwiftUI

@main
struct MattWidgetBundle: WidgetBundle {
    var body: some Widget {
        MattWidget()
    }
}

struct MattWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "matt", provider: MattProvider()) { entry in
            WidgetView(image: entry.image)
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName("Today's Matt Cartoon!")
        .description("Updates Daily")
    }
}
