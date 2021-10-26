//
//  ImageClassifier.swift
//  Diometro
//
//  Created by Vitor Krau on 23/09/20.
//

import Foundation
import Vision
import CoreML
import SwiftUI

class ImageClassifier: ObservableObject{
    
    @Published var label: String = ""
    
    lazy var vnRequest: VNCoreMLRequest = {
        let vnModel = try! VNCoreMLModel(for: Sky(configuration: MLModelConfiguration()).model)
            let request = VNCoreMLRequest(model: vnModel) { [unowned self] request , _ in
                self.processingResult(for: request)
            }
            request.imageCropAndScaleOption = .centerCrop
            return request
    }()
    
    func classify(image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            let ciImage = CIImage(image: image)
            let imageOrientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
            let handler = VNImageRequestHandler(ciImage: ciImage ?? CIImage(), orientation: imageOrientation)
            try! handler.perform([self.vnRequest])
        }
    }
    
    func processingResult(for request: VNRequest) {
        DispatchQueue.main.async {
            let results = (request.results! as! [VNClassificationObservation]).prefix(1)
            self.label = results[0].identifier
        }
    }
    
}
