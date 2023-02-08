//
//  ShareView.swift
//  Change
//
//  Created by Jack Finnis on 16/10/2022.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}

extension View {
    func shareSheet(items: [Any], isPresented: Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            if #available(iOS 16, *) {
                ShareView(items: items)
                    .ignoresSafeArea()
                    .presentationDetents([.medium, .large])
            } else {
                ShareView(items: items)
            }
        }
    }
}
