//
//  FilesVM.swift
//  Speak
//
//  Created by Jack Finnis on 22/01/2023.
//

import UIKit
import Vision

struct VisionHelper {
    static func findText(in uiImage: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = uiImage.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let components = observations.compactMap { $0.topCandidates(1).first }.filter { $0.confidence >= 0.5 }
            completion(components.compactMap { $0.string }.joined(separator: " "))
        }
        request.recognitionLevel = .accurate
        try? handler.perform([request])
    }
}
