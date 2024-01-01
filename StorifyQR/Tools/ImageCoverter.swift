//
//  ImageCoverter.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//

import Foundation
import CoreImage
import UIKit
import SwiftUI

struct ImageCoverter {
    static let context = CIContext()
    
    func convertImage(ciImage: CIImage) -> UIImage {
        if let cgImage = ImageCoverter.context.createCGImage(ciImage, from: ciImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        }
        return UIImage(systemName: "exclamationmark.triangle") ?? UIImage()
    }
}
