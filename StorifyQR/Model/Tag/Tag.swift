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
    var colorComponent: ColorComponents
    var items: [StoredItem]?
    
    init(title: String, 
         isMLSuggested: Bool = false,
         colorComponent: ColorComponents) {
        self.title = title
        self.isMLSuggested = isMLSuggested
        self.colorComponent = colorComponent
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        size = try container.decode(CGFloat.self, forKey: .size)
        isMLSuggested = try container.decode(Bool.self, forKey: .isMLSuggested)
        colorComponent = try container.decode(ColorComponents.self, forKey: .colorComponent)
    }
}
