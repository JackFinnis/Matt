//
//  MattView.swift
//  Matt
//
//  Created by Jack Finnis on 13/01/2023.
//

import SwiftUI
import WidgetKit
import SwiftSoup

struct MattView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var url: URL?
    @State var away = false
    @State var error = false
    
    var body: some View {
        List {}
            .listStyle(.plain)
            .refreshable {
                await fetch()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    WidgetCenter.shared.reloadAllTimelines()
                    Task {
                        await fetch()
                    }
                }
            }
            .overlay {
                if error {
                    WifiError()
                } else if away {
                    MattIsAway()
                } else {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, -50)
                    } placeholder: {
                        ProgressView()
                    }
                    .allowsHitTesting(false)
                }
            }
    }
    
    func fetch() async {
        if let url = await MattHelper.fetchImage() {
            self.url = url
            error = false
        } else {
            error = true
        }
    }
}

struct MattView_Previews: PreviewProvider {
    static var previews: some View {
        MattView()
    }
}
