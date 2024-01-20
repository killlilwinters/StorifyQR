//
//  StoredItem.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//
// https://www.youtube.com/watch?v=Fg1VQsF1RQw&list=PLt46BtfcgiduiZ4StIPPzuD0vPcIZwKW_&index=60&t=291s
//

import Foundation
import SwiftData
import CoreImage
import MapKit
import CoreTransferable

@Model
final class StoredItem: Identifiable, Codable, Transferable {
    let id: UUID
    @Attribute(.externalStorage)
    var photo: Data?
    let name: String
    var itemDescription: String?
    @Relationship(inverse: \Tag.items)
    var tags = [Tag]()
    let dateCreated: Date
    let location: Coordinate2D?
    var qrCode: CIImage {
        let qrGenerator = QRGenerator(inputID: id)
        return qrGenerator.generateQRCode()
    }
    
    init(photo: Data? = nil,
         name: String,
         itemDescription: String?,
         location: Coordinate2D?) {
        self.id = UUID()
        self.photo = photo
        self.name = name
        self.itemDescription = itemDescription
        self.dateCreated = Date()
        self.location = location
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        photo = try? container.decode(Data.self, forKey: .photo)
        name = try container.decode(String.self, forKey: .name)
        itemDescription = try container.decode(String.self, forKey: .itemDescription)
        tags = try container.decode([Tag].self, forKey: .tags)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        location = try container.decode(Coordinate2D.self, forKey: .location)
    }
    
}
