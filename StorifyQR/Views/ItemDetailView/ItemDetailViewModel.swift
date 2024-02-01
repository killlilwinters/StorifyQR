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

    let dataSource: StoredItemDataSource
    
    let item: StoredItem
    var itemProcessedImage: Image? {
        if let itemsPhoto = item.photo {
            return Image(data: itemsPhoto)
        }
        return nil
    }
    var isShowingQR = false
    
    var isShowingAlert = false
    var alertMessage = ""
    
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
    
    func deleteCurrentItem() {
        dataSource.removeItem(item)
    }
    
    init(dataSource: StoredItemDataSource = StoredItemDataSource.shared,
         item: StoredItem) {
        self.dataSource = dataSource
        self.item = item
    }
}
