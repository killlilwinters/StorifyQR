//
//  BaseItemEditingModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.02.2024.
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
class BaseItemEditing {
    
    @ObservationIgnored
    let dataSource: StoredItemDataSource
    
    var name = ""
    var isShowingNameWarning = false
    var itemDescription = ""
    
    var pickerItem: PhotosPickerItem?
    var photoData: Data?
    var image: Image?
    
    var isShowingSheet = false
    var isShowingAlert = false
    
    var tags = [Tag]()
    
    func loadImage() {
        Task {
            await ImageCoverter.shared.loadImage(pickerItem: pickerItem!) { photoData, image, error in
                if error == nil {
                    self.photoData = photoData
                    self.image = image
                } else {
                    print(error ?? "Unknown error")
                }
            }
        }
    }
    
    func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    func checkIsNameFilled() -> Bool {
        isShowingNameWarning = false
        guard !name.isEmpty else {
            isShowingNameWarning = true
            return false
        }
        return true
    }
    
    init(dataSource: StoredItemDataSource = StoredItemDataSource.shared,
         name: String = "",
         isShowingNameWarning: Bool = false,
         itemDescription: String = "",
         pickerItem: PhotosPickerItem? = nil,
         photoData: Data? = nil,
         image: Image? = nil,
         isShowingSheet: Bool = false,
         isShowingAlert: Bool = false,
         tags: [Tag] = [Tag]()) {
        self.dataSource = dataSource
        self.name = name
        self.isShowingNameWarning = isShowingNameWarning
        self.itemDescription = itemDescription
        self.pickerItem = pickerItem
        self.photoData = photoData
        self.image = image
        self.isShowingSheet = isShowingSheet
        self.isShowingAlert = isShowingAlert
        self.tags = tags
    }
    
    func askToSave() {
        guard checkIsNameFilled() else { return }
        isShowingAlert = true
    }
    
}
