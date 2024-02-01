//
//  ImageCoverter.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.01.2024.
//
// https://www.hackingwithswift.com/quick-start/beginners/how-to-return-multiple-values-from-functions
//

import Foundation
import CoreImage
import UIKit
import SwiftUI
import PhotosUI

struct ImageCoverter {
    static let shared = ImageCoverter()
    static let context = CIContext()
    
    func convertImage(ciImage: CIImage) -> UIImage {
        if let cgImage = ImageCoverter.context.createCGImage(ciImage, from: ciImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
        }
        return UIImage(systemName: "exclamationmark.triangle") ?? UIImage()
    }
    
    func loadImage(pickerItem: PhotosPickerItem, 
                   completionHandler: @escaping ((photoData: Data?, image: Image?, error: String?)) -> Void) async {
        do {
            guard let rawImage = try await pickerItem.loadTransferable(type: Data.self) else { return }
            let fullUIImage = UIImage(data: rawImage)
            let photoData = fullUIImage?.jpeg(.low)
            let compressedUIImage = UIImage(data: photoData!)
            let image = Image(uiImage: compressedUIImage!)
            completionHandler((photoData, image, nil))
        } catch {
            completionHandler((nil, nil, error.localizedDescription))
        }
    }
}
