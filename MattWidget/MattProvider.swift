//
//  MattWidget.swift
//  MattWidget
//
//  Created by Jack Finnis on 13/01/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Entry: TimelineEntry {
    let date = Date()
    let image: Image?
}

struct MattProvider: TimelineProvider {
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
            case .success(let cartoom):
                completion(Image(uiImage: cartoom.uiImage))
            case .away:
                completion(nil)
            case .wifiError:
                break
            }
        }
    }
}
