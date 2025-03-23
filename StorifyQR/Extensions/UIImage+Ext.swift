//
//  UIImage+Ext.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.01.2024.
//
// https://medium.com/@grujic.nikola91/resize-uiimage-in-swift-3e51f09f7a02
//
// https://stackoverflow.com/questions/3900474/how-to-scale-up-an-uiimage-without-smoothening-anything
//

import UIKit
import AVFoundation

public extension UIImage {
    func resize(_ width: Int = 1024, _ height: Int = 1024) -> UIImage {
        let maxSize = CGSize(width: width, height: height)

        let availableRect = AVFoundation.AVMakeRect(
            aspectRatio: self.size,
            insideRect: .init(origin: .zero, size: maxSize)
        )
        let targetSize = availableRect.size
        UIGraphicsBeginImageContext(targetSize)
        let scaledContext = UIGraphicsGetCurrentContext()!
        scaledContext.interpolationQuality = .none

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()!

        return scaledImage
    }
}

//
// https://stackoverflow.com/questions/29726643/how-to-compress-of-reduce-the-size-of-an-image-before-uploading-to-parse-as-pffi
//
// https://stackoverflow.com/a/61055279/23215434
//

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UIImage {
    public func resized(to target: CGSize) -> UIImage {
        let ratio = min(
            target.height / size.height, target.width / size.width
        )
        let new = CGSize(
            width: size.width * ratio, height: size.height * ratio
        )
        let renderer = UIGraphicsImageRenderer(size: new)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: new))
        }
    }
}
