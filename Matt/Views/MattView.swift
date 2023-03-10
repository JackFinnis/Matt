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
    @StateObject var mattVM = MattVM()
    
    @State var cartoon: Cartoon?
    @State var error = false
    @State var away = false
    @State var noWidgets = false
    
    @State var showShareSheet = false
    @State var showAddWidgetView = false
    @State var showFavouritesView = false
    
    @State var scale = 1.0
    @State var shake = false
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM"
        return formatter.string(from: .now)
    }
    
    var body: some View {
        NavigationView {
            List {}
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Today")
                .refreshable {
                    await fetch()
                }
                .overlay {
                    if error {
                        WifiError()
                    } else if away {
                        MattLogo(caption: " is away ")
                    } else if let cartoon {
                        Image(uiImage: cartoon.uiImage)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, -30)
                            .padding(.bottom, 30)
                            .allowsHitTesting(false)
                            .shareCartoon(cartoon: cartoon, isPresented: $showShareSheet)
                            .toolbar {
                                toolbarItems(cartoon: cartoon)
                            }
                    } else {
                        ProgressView()
                    }
                    NavigationLink("", isActive: $showFavouritesView) {
                        FavouritesView(mattVM: mattVM)
                    }
                    .hidden()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(date)
                            .font(.headline)
                    }
                }
                .overlay(alignment: .bottom) {
                    if noWidgets {
                        Button {
                            showAddWidgetView = true
                        } label: {
                            Label("Add Widget", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .labelStyle(.titleAndIcon)
                        }
                        .padding()
                    }
                }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                WidgetCenter.shared.reloadAllTimelines()
                
                WidgetCenter.shared.getCurrentConfigurations { result in
                    switch result {
                    case .success(let widgets):
                        noWidgets = widgets.isEmpty
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
                
                Task {
                    error = false
                    away = false
                    await fetch()
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    func toolbarItems(cartoon: Cartoon) -> some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            HStack {
                Button {
                    showAddWidgetView = true
                } label: {
                    Image(systemName: "questionmark.circle")
                }
                .sheet(isPresented: $showAddWidgetView) {
                    AddWidgetView(cartoon: cartoon)
                }
                
                Button {
                    showFavouritesView = true
                } label: {
                    Image(systemName: "list.star")
                }
            }
        }
        ToolbarItem(placement: .primaryAction) {
            HStack {
                let favourite = mattVM.favourites.contains(cartoon.url.absoluteString)
                Button {
                    let urlString = cartoon.url.absoluteString
                    if favourite {
                        mattVM.favourites.removeAll { $0 == urlString }
                    } else {
                        mattVM.favourites.append(urlString)
                        Haptics.tap()
                        
                        shake = true
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                            shake = false
                        }
                        withAnimation(.easeInOut(duration: 0.25)) {
                            scale = 1.3
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                scale = 1
                            }
                        }
                    }
                } label: {
                    Image(systemName: favourite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(shake ? 20 : 0))
                }
                
                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    func fetch() async {
        switch await MattHelper.fetchCartoon() {
        case .success(let cartoon):
            self.cartoon = cartoon
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
