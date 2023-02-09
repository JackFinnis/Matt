//
//  WifiError.swift
//  News
//
//  Created by Jack Finnis on 13/01/2023.
//

import SwiftUI

struct WifiError: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 10) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 40))
                    .foregroundColor(.secondary)
                VStack(spacing: 5) {
                    Text("No Internet Connection")
                        .font(.title3.bold())
                    Text("Please make sure you are connected to WiFi or Mobile data, and then try again.")
                        .padding(.horizontal)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .allowsHitTesting(false)
            
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            }
            .font(.headline)
        }
    }
}
