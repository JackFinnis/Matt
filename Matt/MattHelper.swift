//
//  MattHelper.swift
//  Matt
//
//  Created by Jack Finnis on 25/01/2023.
//

import Foundation
import SwiftSoup

struct MattHelper {
    static func fetchImage() async -> URL? {
        do {
            let url = URL(string: "https://www.telegraph.co.uk")!
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            let doc = try SwiftSoup.parse(html)
            let elems = try doc.getAllElements().array()
            guard let pic = try elems.first(where: { try $0.attr("alt") == "Matt cartoon" }) else { return nil }
            let path = try pic.attr("src")
            guard var components = URLComponents(string: url.absoluteString + path) else { return nil }
            components.query = nil
            return components.url
        } catch {
            return nil
        }
    }
}
