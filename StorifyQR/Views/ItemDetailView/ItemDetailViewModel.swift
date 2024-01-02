//
//  ItemDetailViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//

import Foundation
import UIKit
import SwiftUI

@Observable
final class ItemDetailViewModel {
    static let imageConverter = ImageCoverter()
    let qrTip = QRCodeShareTip()
    
    let item: StoredItem
    var isShowingQR = false
    
    func getDate() -> String {
        let dateConverter = DateConverter(date: item.dateCreated)
        return dateConverter.format()
    }
    
    func getQR() -> UIImage {
        ItemDetailViewModel.imageConverter.convertImage(ciImage: item.qrCode)
    }
    
    func shareQR() -> Image {
        return Image(uiImage: getQR().resize(1500, 1500))
    }
    
    init(item: StoredItem) {
        self.item = item
    }
}
