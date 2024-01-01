//
//  StoredItem.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//

import Foundation
import SwiftData
import CoreImage

enum Tags {
    case fruits
}

@Model
final class StoredItem {
    let id: UUID
//  let photo: Image
    let name: String
    var itemDescription: String
//  let tag: Tags
    let dateCreated: Date
    var qrCode: CIImage {
        let qrGenerator = QRGenerator(inputID: id)
        return qrGenerator.generateQRCode()
    }
    
    init(name: String, itemDescription: String) {
        self.id = UUID()
        self.name = name
        self.itemDescription = itemDescription
        self.dateCreated = Date()
    }
}
