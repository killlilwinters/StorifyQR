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
class ItemDetailViewModel {
    static let imageConverter = ImageCoverter()
    let qrTip = QRCodeShareTip()

    @MainActor let dataSource = StoredItemDataSource.shared
    
    let item: StoredItem
    var image: Image? {
        return item.photo.flatMap { Image(data: $0) }
    }
    
    var isShowingQR = false
    
    var isShowingAlert = false
    var alertMessage = ""
    
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
