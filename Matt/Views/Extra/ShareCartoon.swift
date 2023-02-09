//
//  ShareView.swift
//  Change
//
//  Created by Jack Finnis on 16/10/2022.
//

import SwiftUI
import LinkPresentation

struct ShareCartoon: UIViewControllerRepresentable {
    let cartoon: Cartoon
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [context.coordinator], applicationActivities: nil)
    }
    
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
    
    class Coordinator: NSObject, UIActivityItemSource {
        let parent: ShareCartoon
        
        init(_ parent: ShareCartoon) {
            self.parent = parent
        }
        
        func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
            return ""
        }
        
        func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
            return parent.cartoon.uiImage
        }

        func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
            return parent.cartoon.uiImage
        }

        func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
            let metadata = LPLinkMetadata()
            metadata.title = "Matt Cartoon"
            metadata.imageProvider = NSItemProvider(object: parent.cartoon.uiImage)
            return metadata
        }
    }
}

extension View {
    func shareCartoon(cartoon: Cartoon, isPresented: Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            if #available(iOS 16, *) {
                ShareCartoon(cartoon: cartoon)
                    .ignoresSafeArea()
                    .presentationDetents([.medium, .large])
            } else {
                ShareCartoon(cartoon: cartoon)
            }
        }
    }
}
