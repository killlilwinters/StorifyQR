//
//  Tag.swift
//  StorifyQR
//
//  Created by Maks Winters on 08.01.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Tag {
    @Attribute(.unique)
    let title: String
    var size: CGFloat = 0
    var colorComponent: ColorComponents
    var item: [StoredItem]?
    
    init(title: String, colorComponent: ColorComponents) {
        self.title = title
        self.colorComponent = colorComponent
    }
}
