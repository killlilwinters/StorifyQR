//
//  ItemDetailViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//

import UIKit
import SwiftUI

@Observable
class ItemDetailViewModel {
    @MainActor let dataSource = StoredItemDataSource.shared
    static let imageConverter = ImageCoverter()
    
    let qrTip = QRCodeShareTip()
    
    let item: StoredItem
    
    var isShowingQR = false
    
    var isShowingAlert = false
    var alertMessage = ""
    
    var image: Image? {
        item.image
    }
    
    func getDate() -> String {
        let dateConverter = DateConverter(date: item.dateCreated)
        return dateConverter.format()
    }
    
    func getQR() -> Image {
        let uiImage = ItemDetailViewModel.imageConverter.convertImage(ciImage: item.qrCode)
        return Image(uiImage: uiImage.resize())
    }
    
    @MainActor
    func shareQR() -> ShareableImage {
        let renderer = ImageRenderer(content: SQRWatermark(item: item))
        let uiImage = renderer.uiImage
        return ShareableImage(image: uiImage!, filename: item.name)
    }
    
    @MainActor
    func deleteCurrentItem() {
        dataSource.removeItem(item)
    }
    
    init(item: StoredItem) {
        self.item = item
    }
}
