//
//  MattView.swift
//  Matt
//
//  Created by Jack Finnis on 13/01/2023.
//

import SwiftUI

struct MattView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var url: URL?
    @State var away = false
    @State var error = false
    
    var body: some View {
        List {}
            .refreshable {
                await fetch()
            }
            .task {
                await fetch()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
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
        error = false
        let url = URL(string: "https://matt.finnisjack.repl.co")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            let urlString = String(data: data, encoding: .utf8)
            if let urlString, let url = URL(string: urlString) {
                self.url = url
                away = false
            } else if urlString == "away" {
                away = true
            } else {
                self.error = true
            }
        } catch {
            debugPrint(error)
            self.error = true
        }
    }
}

struct MattView_Previews: PreviewProvider {
    static var previews: some View {
        MattView()
    }
}
