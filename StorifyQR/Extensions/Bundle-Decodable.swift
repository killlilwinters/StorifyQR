//
//  Bundle-Decodable.swift
//  StorifyQR
//
//  Created by Maks Winters on 24.01.2024.
//

import Foundation

enum Errors: String, Error {
    case loadError = "This file couldn't be loaded"
    case decodeError = "This file couldn't be read"
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
