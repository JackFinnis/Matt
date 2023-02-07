//
//  MattHelper.swift
//  Matt
//
//  Created by Jack Finnis on 25/01/2023.
//

import Foundation
import SwiftSoup

struct MattHelper {
    static func fetchImage() async -> MattHelper.Result {
        let url = URL(string: "https://www.telegraph.co.uk")!
        
        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch {
            return .wifiError
        }
        
        do {
            guard let html = String(data: data, encoding: .utf8) else { return .away }
            let doc = try SwiftSoup.parse(html)
            let elems = try doc.getAllElements().array()
            guard let pic = try elems.first(where: { try $0.attr("alt") == "Matt cartoon" }) else { return .away }
            let path = try pic.attr("src")
            guard var components = URLComponents(string: url.absoluteString + path) else { return .away }
            components.query = nil
            guard let url = components.url else { return .away }
            return .success(url)
        } catch {
            return .away
        }
    }
    
    enum Result {
        case success(URL)
        case away
        case wifiError
    }
}
