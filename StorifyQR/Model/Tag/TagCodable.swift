//
//  TagCodable.swift
//  StorifyQR
//
//  Created by Maks Winters on 19.01.2024.
//

import Foundation

extension Tag {
    enum CodingKeys: CodingKey {
        case title
        case size
        case colorComponent
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(size, forKey: .size)
        try container.encode(colorComponent, forKey: .colorComponent)
        // Not encoding items since Many to Many relationships cause circular refernces and loops whipe exporting leading to a crash
    }
}
