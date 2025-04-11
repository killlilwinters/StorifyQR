//
//  AbstractClassifier.swift
//  StorifyQR
//
//  Created by Maks Winters on 27.04.2024.
//

import SwiftUI

final class AbstractClassifier: ObservableObject {
    enum MLError: Error, LocalizedError {
        case detectionError
        case ciImageError
        
        var errorDescription: String? {
            switch self {
            case .detectionError: "Error detecting an image"
            case .ciImageError:   "Error converting UIImage to CIImage"
            }
        }
    }
    
    @Published private var classifier = Classifier()
    
    var imageClass: String? {
        classifier.results
    }
    var otherResults: [String] {
        print("Called with count of: \(classifier.validResultsArray)")
        return classifier.validResultsArray
    }
    var getFirst: String? {
        classifier.validResultsArray.first
    }
    
    // MARK: Intent(s)
    func detect(uiImage: UIImage) throws {
        guard let ciImage = CIImage(image: uiImage) else {
            throw MLError.ciImageError
        }
        do {
            try classifier.detect(ciImage: ciImage)
        } catch {
            throw error
        }
        
    }
    
}

// MARK: - Hashable conformance
extension AbstractClassifier: Hashable {
    static func == (lhs: AbstractClassifier, rhs: AbstractClassifier) -> Bool {
        lhs.classifier == rhs.classifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(classifier)
    }
}
