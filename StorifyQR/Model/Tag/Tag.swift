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

import Foundation
import SwiftData
import SwiftUI
import CoreTransferable

@Model
class Tag {
    @Attribute(.unique)
    let title: String
    var size: CGFloat = 0
    let isMLSuggested = false
    var color: String
    var tagColor: Color {
        get {
            // Convert tagColor string to Color
            return ColorComponents.decodeTagColor(colorString: color)
        }
        set {
            // Convert Color to string and assign to tagColor
            color = ColorComponents.encodeTagColor(color: newValue)
        }
    }
    var items: [StoredItem]?
    
    init(title: String, 
         isMLSuggested: Bool = false,
         tagColor: Color) {
        self.title = title
        self.isMLSuggested = isMLSuggested
        self.color = ColorComponents.encodeTagColor(color: tagColor)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        size = try container.decode(CGFloat.self, forKey: .size)
        isMLSuggested = try container.decode(Bool.self, forKey: .isMLSuggested)
        color = try container.decode(String.self, forKey: .tagColor)
    }
}
