//
//  AbstractClassifier.swift
//  StorifyQR
//
//  Created by Maks Winters on 27.04.2024.
//

import SwiftUI

// TODO: Better error handling
enum MLError: Error {
    case detectionError
    case noResults
    case noFirstResult
    case noData
}

class AbstractClassifier: ObservableObject {
    
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
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage(image: uiImage) else {
            print("Failed to convert UIImage to CIImage")
            return
        }
        print("CIImage created, initiating classification process")
        classifier.detect(ciImage: ciImage)
        
    }
    
}
