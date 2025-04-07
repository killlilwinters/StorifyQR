//
//  Tag.swift
//  StorifyQR
//
//  Created by Maks Winters on 08.01.2024.
//
// https://developer.apple.com/forums/thread/70775
//
// https://www.youtube.com/watch?v=lHdBkXp3j74
//

import SwiftData
import SwiftUI
import CoreTransferable

@Model
final class Tag: SwiftDataItem {
    @Attribute(.unique)
    var title: String
    var size: CGFloat = 0
    var isMLSuggested = false
    var color: String
    var tagColor: Color {
        get {
            // Convert tagColor string to Color
            return TagColors.decodeTagColor(from: color)
        }
        set {
            // Convert Color to string and assign to tagColor
            color = TagColors.encodeTagColor(from: newValue)
        }
    }
    var items: [StoredItem]?
    
    init(title: String,
         isMLSuggested: Bool = false,
         tagColor: Color
    ) {
        // Check if the color is in TagColors
        if !TagColors.isColorInTagColors(tagColor) {
            assertionFailure("Color not in TagColors")
        }
        
        self.color = TagColors.encodeTagColor(from: tagColor)
        
        self.title = title
        self.isMLSuggested = isMLSuggested
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        size = try container.decode(CGFloat.self, forKey: .size)
        isMLSuggested = try container.decode(Bool.self, forKey: .isMLSuggested)
        color = try container.decode(String.self, forKey: .tagColor)
    }
}

// MARK: - Hashable, Comparable conformance
extension Tag: Hashable, Comparable { }
