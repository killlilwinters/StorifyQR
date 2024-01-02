//
//  UIImage-Resize.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.01.2024.
//
// https://medium.com/@grujic.nikola91/resize-uiimage-in-swift-3e51f09f7a02
// https://stackoverflow.com/questions/3900474/how-to-scale-up-an-uiimage-without-smoothening-anything
//

import UIKit
import AVFoundation

public extension UIImage {
    func resize(_ width: Int, _ height: Int) -> UIImage {
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
