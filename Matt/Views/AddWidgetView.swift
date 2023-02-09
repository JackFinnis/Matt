//
//  AddWidgetView.swift
//  Matt
//
//  Created by Jack Finnis on 08/02/2023.
//

import SwiftUI

struct AddWidgetView: View {
    @Environment(\.dismiss) var dismiss
    @State var tab = -1
    
    let cartoon: Cartoon
    let steps = [
        "Open your home screen. Press and hold on the wallpaper to enter edit mode.",
        "Tap the + at the top left.",
        "Tap on \"Search Widgets\" at the top.",
        "Enter \"Matt\" in the search bar then tap on the first result.",
        "Tap on \"Add Widget\" at the bottom",
        "The Matt Widget is now on your home screen! It will update daily."
    ]
    
    init(cartoon: Cartoon) {
        self.cartoon = cartoon
        UIPageControl.appearance().currentPageIndicatorTintColor = .label
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $tab) {
                VStack {
                    Spacer()
                    Image(uiImage: cartoon.uiImage)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.15), radius: 10)
                    
                    Text("The Matt Widget shows you today's Matt Cartoon on your home screen!")
                        .padding(.top)
                    Spacer()
                    Button {
                        withAnimation {
                            tab = 0
                        }
                    } label: {
                        Text("Continue")
                            .bigButton()
                    }
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                .tag(-1)
                
                ForEach(0...5, id: \.self) { i in
                    VStack(spacing: 20) {
                        Image("\(i)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(30)
                        Text(steps[i])
                            .multilineTextAlignment(.center)
                            .frame(height: 50)
                        if i == 5 {
                            Button {
                                dismiss()
                            } label: {
                                Text("Done")
                                    .bigButton()
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)
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
                AddWidgetView(cartoon: Cartoon(uiImage: UIImage(named: "cartoon")!, url: URL(string: "bbc.com")!))
            }
    }
}
