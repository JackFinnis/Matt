//
//  AddWidgetView.swift
//  Matt
//
//  Created by Jack Finnis on 08/02/2023.
//

import SwiftUI

struct AddWidgetView: View {
    @Environment(\.dismiss) var dismiss
    
    let steps = [
        "Open your home screen. Press and hold on the wallpaper to enter edit mode.",
        "Tap the + at the top left.",
        "Tap on \"Search Widgets\" at the top.",
        "Enter \"Matt\" in the search bar then tap on the first result.",
        "Tap on \"Add Widget\" at the bottom",
        "The Matt Widget is now on your home screen! It will update daily."
    ]
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .label
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
    }
    
    var body: some View {
        NavigationView {
            TabView {
                ForEach(0...5, id: \.self) { i in
                    VStack {
                        Image("\(i)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(steps[i])
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .frame(height: 50)
                    }
                }
                .padding(.bottom, 40)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        DismissCross()
                    }
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: .principal) {
                    DraggableBar("How to add the Matt Widget")
                }
            }
        }
    }
}

struct AddWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                AddWidgetView()
            }
    }
}
