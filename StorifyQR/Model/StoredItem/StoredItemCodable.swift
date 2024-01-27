//
//  StoredItemCodable.swift
//  StorifyQR
//
//  Created by Maks Winters on 19.01.2024.
//
// https://www.hackingwithswift.com/quick-start/swiftdata/how-to-make-swiftdata-models-conform-to-codable
//

import Foundation
import CoreTransferable

extension StoredItem: Codable {
    enum CodingKeys: CodingKey {
        case id
        case photo
        case name
        case itemDescription
        case tags
        case dateCreated
        case location
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(photo, forKey: .photo)
        try container.encode(name, forKey: .name)
        try container.encode(itemDescription, forKey: .itemDescription)
        try container.encode(tags, forKey: .tags)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(location, forKey: .location)
    }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation<StoredItem, JSONEncoder, JSONDecoder>(contentType: .sqrExportType)
            .suggestedFileName("StorifyQR\(Date())")
    }
    
}
