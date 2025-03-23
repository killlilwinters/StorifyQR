//
//  Image+Ext.swift
//  StorifyQR
//
//  Created by Maks Winters on 31.01.2024.
//

import SwiftUI

extension Image {
    init?(data imageData: Data) {
        guard let uiImage = UIImage(data: imageData) else {
            return nil
        }
        
        self = Image(uiImage: uiImage)
    }
}
