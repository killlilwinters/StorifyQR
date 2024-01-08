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
//  let photo: Image
    let name: String
    var itemDescription: String?
    var tags = [Tag]()
    let dateCreated: Date
    let location: Coordinate2D?
    var qrCode: CIImage {
        let qrGenerator = QRGenerator(inputID: id)
        return qrGenerator.generateQRCode()
    }
    
    init(name: String, itemDescription: String?, location: Coordinate2D?) {
        self.id = UUID()
        self.name = name
        self.itemDescription = itemDescription
        self.dateCreated = Date()
        self.location = location
    }
}
