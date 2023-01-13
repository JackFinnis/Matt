//
//  MattWidget.swift
//  MattWidget
//
//  Created by Jack Finnis on 13/01/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(image: Image("cartoon"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        fetch { image in
            completion(Entry(image: image))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        fetch { image in
            let entry = Entry(image: image)
            let timeline = Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(3600)))
            completion(timeline)
        }
    }
    
    func fetch(completion: @escaping (Image?) -> Void) {
        Task {
            let url = URL(string: "https://matt.finnisjack.repl.co")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let urlString = String(data: data, encoding: .utf8)
                if let urlString, let url = URL(string: urlString) {
                    
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let uiImage = UIImage(data: data) {
                        completion(Image(uiImage: uiImage))
                    }
                    
                } else if urlString == "away" {
                    completion(nil)
                }
            } catch {}
        }
    }
}

struct Entry: TimelineEntry {
    let date = Date()
    let image: Image?
}

struct WidgetView: View {
    let image: Image?

    var body: some View {
        ZStack {
            Color.white
            if let image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                MattIsAway()
            }
        }
    }
}

struct MattWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "matt", provider: Provider()) { entry in
            WidgetView(image: entry.image)
        }
        .supportedFamilies([.systemLarge, .systemSmall])
        .configurationDisplayName("Today's Matt Cartoon!")
    }
}
