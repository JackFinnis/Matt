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
            let oneHour = Date.now.addingTimeInterval(3600)
            let timeline = Timeline(entries: [entry], policy: .after(oneHour))
            completion(timeline)
        }
    }
    
    func fetch(completion: @escaping (Image?) -> Void) {
        Task {
            switch await MattHelper.fetchImage() {
            case .success(let url):
                guard let (data, _) = try? await URLSession.shared.data(from: url),
                      let uiImage = UIImage(data: data)
                else { return }
                
                completion(Image(uiImage: uiImage))
            case .away:
                completion(nil)
            case .wifiError:
                break
            }
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
