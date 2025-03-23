//
//  String+Ext.swift
//  StorifyQR
//
//  Created by Maks Winters on 20.05.2024.
//

import UIKit

// Limit TextField
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

// Get string size
extension String {
    func getSize() -> CGFloat{
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }
}
