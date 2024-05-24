//
//  StringLimiter.swift
//  StorifyQR
//
//  Created by Maks Winters on 20.05.2024.
//

import Foundation

extension String {
    func limit(limit: Int) -> String {
        let append = self.count > limit
        return self.prefix(limit).appending(
            append ? "..." : ""
        )
    }
    
    mutating func limitTextField(limit: Int) {
        if self.count > limit {
            self = String(self.prefix(limit))
        }
    }
}
