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
    @State var error = false
    @State var away = false
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        return formatter.string(from: .now)
    }
    
    var body: some View {
        NavigationView {
            List {}
                .listStyle(.plain)
                .refreshable {
                    await fetch()
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
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(date)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Menu {
                            Button {
                                
                            } label: {
                                Label("Favourites", systemImage: "star")
                            }
                            Button {
                                
                            } label: {
                                Label("How to add Widget", systemImage: "questionmark.circle")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            
                        } label: {
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                        }
                    }
                }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                WidgetCenter.shared.reloadAllTimelines()
                WidgetCenter.shared.getCurrentConfigurations { result in
                    switch result {
                    case .success(let widgets):
                        print("\(widgets.count) widgets")
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
                
                Task {
                    await fetch()
                }
            }
        }
    }
    
    func fetch() async {
        switch await MattHelper.fetchImage() {
        case .success(let url):
            self.url = url
            error = false
            away = false
        case .wifiError:
            error = true
            away = false
        case .away:
            away = true
            error = false
        }
    }
}

struct MattView_Previews: PreviewProvider {
    static var previews: some View {
        MattView()
    }
}
