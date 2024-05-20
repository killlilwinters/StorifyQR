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
}
