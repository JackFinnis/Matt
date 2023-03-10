//
//  BigLabel.swift
//  News
//
//  Created by Jack Finnis on 13/01/2023.
//

import SwiftUI

struct ErrorLabel: View {
    let systemName: String
    let tint: Color
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemName)
                .font(.system(size: 40))
                .foregroundColor(tint)
            VStack(spacing: 5) {
                Text(title)
                    .font(.title3.bold())
                Text(message)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .allowsHitTesting(false)
    }
}
