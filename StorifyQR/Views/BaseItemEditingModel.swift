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
    var location: CLLocationCoordinate2D?
    
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
         item: StoredItem? = nil) {
        self.dataSource = dataSource
        self.name = item?.name ?? ""
        self.itemDescription = item?.itemDescription ?? ""
        self.location = item?.location?.getCLLocation() ?? nil
        self.image = item?.photo != nil ? Image(data: item!.photo!) : nil
        self.tags = item?.tags ?? [Tag]()
    }
    
    func askToSave() {
        guard checkIsNameFilled() else { return }
        isShowingAlert = true
    }
    
}
