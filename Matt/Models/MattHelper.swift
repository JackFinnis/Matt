//
//  MattHelper.swift
//  Matt
//
//  Created by Jack Finnis on 25/01/2023.
//

import UIKit
import SwiftSoup

class Cartoon {
    let uiImage: UIImage
    let url: URL
    var caption = ""
    
    init(uiImage: UIImage, url: URL) {
        self.uiImage = uiImage
        self.url = url
    }
    
    func getCaption(completion: @escaping () -> Void) {
        VisionHelper.findText(in: uiImage) { string in
            self.caption = string
            completion()
        }
    }
}

struct MattHelper {
    static func fetchCartoon() async -> MattHelper.Result {
        let telegraph = URL(string: "https://www.telegraph.co.uk")!
        
        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: telegraph)
        } catch {
            return .wifiError
        }
        
        let url: URL
        do {
            guard let html = String(data: data, encoding: .utf8) else { return .away }
            let doc = try SwiftSoup.parse(html)
            let elems = try doc.getAllElements().array()
            guard let pic = try elems.first(where: { try $0.attr("alt") == "Matt cartoon" }) else { return .away }
            let path = try pic.attr("src")
            guard var components = URLComponents(string: telegraph.absoluteString + path) else { return .away }
            components.query = nil
            guard let mattUrl = components.url else { return .away }
            url = mattUrl
        } catch {
            return .away
        }
        
        if let uiImage = await UIImage(loadFrom: url) {
            return .success(Cartoon(uiImage: uiImage, url: url))
        } else {
            return .wifiError
        }
    }
    
    enum Result {
        case success(Cartoon)
        case away
        case wifiError
    }
}
