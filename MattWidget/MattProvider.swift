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
    let state: WidgetView.State
}

struct MattProvider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(state: .loading)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        fetch { state in
            completion(Entry(state: state))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        fetch { state in
            let entry = Entry(state: state)
            let oneHour = Date.now.addingTimeInterval(3600)
            let timeline = Timeline(entries: [entry], policy: .after(oneHour))
            completion(timeline)
        }
    }
    
    func fetch(completion: @escaping (WidgetView.State) -> Void) {
        Task {
            switch await MattHelper.fetchCartoon() {
            case .success(let cartoom):
                completion(.cartoon(Image(uiImage: cartoom.uiImage)))
            case .away:
                completion(.away)
            case .wifiError:
                break
            }
        }
    }
}
