//
//  Bundle-Decodable.swift
//  StorifyQR
//
//  Created by Maks Winters on 24.01.2024.
//

import Foundation

#warning("Better error handling needed to the UI")
enum Errors: Error, LocalizedError {
    case loadError
    case decodeError
    // ML
    case noImageData
    case ivalidImageData
    
    var errorDescription: String? {
        switch self {
        case .loadError:       "This file couldn't be loaded"
        case .decodeError:     "This file couldn't be read"
        case .noImageData:     "No image data provided for classification"
        case .ivalidImageData: "Failed to convert image data to UIImage"
        }
    }
}

extension Bundle {
    func decode<T: Codable>(_ url: URL) throws -> T {
        
        do {
            let loaded = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            
            let decoded = try decoder.decode(T.self, from: loaded)
            
            return decoded
            
        } catch {
            throw error
        }
    }
}
