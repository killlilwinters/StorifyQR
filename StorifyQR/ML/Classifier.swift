//
//  Classifier.swift
//  StorifyQR
//
//  Created by Maks Winters on 27.04.2024.
//
// https://stackoverflow.com/questions/75863781/code-9-could-not-create-inference-context-coreml-ios
//

import CoreML
import Vision
import CoreImage

struct Classifier {
    enum ClassificationError: Error, LocalizedError {
        case noResults, modelLoadingFailed
        
        var errorDescription: String? {
            switch self {
            case .noResults: "No classification results available."
            case .modelLoadingFailed: "Failed to load the model."
                
            }
        }
    }
    
    
    let minimumConfidence: VNConfidence = 0.05
    lazy var getModel: VNCoreMLModel? = {
        let config = MLModelConfiguration()
        
        return try? VNCoreMLModel(for: StorifyQRImageClassifierV2_3(configuration: config).model)
    }()
    
    
    private(set) var results: String?
    private(set) var validResultsArray = [String]()
    
    mutating func detect(ciImage: CIImage) throws(ClassificationError) {
        validResultsArray.removeAll()
        
        guard let model = getModel else { throw .modelLoadingFailed }
        
        let request = VNCoreMLRequest(model: model)
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: .init())
        
        do {
            // MARK: Won't work on the Simulator, use iPad verion for Mac for testing from now on
//            #if targetEnvironment(simulator)
//            request.usesCPUOnly = true
//            #endif
            try handler.perform([request])
            if let results = request.results as? [VNClassificationObservation], let firstResult = results.first {
                self.results = firstResult.identifier

                results.forEach { observation in
                    if observation.confidence > minimumConfidence {
                        
                        let observationString = observation.identifier
                        validResultsArray.append(observationString)
                        
                    }
                }
                
            } else {
                throw ClassificationError.noResults
            }
        } catch {
            print("Error in classification request: \(error)")
        }
        
    }
    
}

// MARK: - Hashable conformance
extension Classifier: Hashable { }

