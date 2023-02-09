//
//  UIImage.swift
//  Matt
//
//  Created by Jack Finnis on 09/02/2023.
//

import UIKit

extension UIImage {
    convenience init?(loadFrom url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.init(data: data)
        } catch {
            return nil
        }
    }
}
