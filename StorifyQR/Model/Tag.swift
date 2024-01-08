//
//  Tag.swift
//  StorifyQR
//
//  Created by Maks Winters on 08.01.2024.
//

import Foundation
import SwiftData

@Model
class Tag {
    @Attribute(.unique)
    let title: String
    var item: StoredItem?
    
    init(title: String, item: StoredItem? = nil) {
        self.title = title
        self.item = item
    }
}
