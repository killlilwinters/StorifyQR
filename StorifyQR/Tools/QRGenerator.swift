//
//  QRGenerator.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//

import CoreImage
import CoreImage.CIFilterBuiltins

struct QRGenerator {
    static let filter = CIFilter.qrCodeGenerator()
    let inputID: UUID
    
    func generateQRCode() -> CIImage {
        let string = inputID.uuidString
        QRGenerator.filter.message = Data(string.utf8)
        if let outputImage = QRGenerator.filter.outputImage {
            return outputImage
        }
        return CIImage()
    }
}
