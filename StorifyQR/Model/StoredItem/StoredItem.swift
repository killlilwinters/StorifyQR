//
//  StoredItem.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//

import Foundation
import SwiftData
import CoreImage
import MapKit

@Model
final class StoredItem: Identifiable {
    let id: UUID
    @Attribute(.externalStorage)
    var photo: Data?
    let name: String
    var itemDescription: String?
    @Relationship(inverse: \Tag.item)
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
}
