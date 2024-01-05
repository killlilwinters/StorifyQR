//
//  NewItemViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 05.01.2024.
//
// https://dev.to/jameson/swiftui-with-swiftdata-through-repository-36d1
//
// https://www.youtube.com/watch?v=4-Q14fCm-VE
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
final class NewItemViewModel {
    
    @ObservationIgnored
    private let dataSource: StoredItemDataSource
    
    var name = ""
    var isShowingNameWarning = false
    var itemDescription = ""
    var pickerItem: PhotosPickerItem?
    var image: Image?
    var isShowingAlert = false
    
    init(dataSource: StoredItemDataSource = StoredItemDataSource.shared, name: String = "", isShowingNameWarning: Bool = false, itemDescription: String = "", pickerItem: PhotosPickerItem? = nil, image: Image? = nil, isShowingAlert: Bool = false) {
        self.dataSource = dataSource
        self.name = name
        self.isShowingNameWarning = isShowingNameWarning
        self.itemDescription = itemDescription
        self.pickerItem = pickerItem
        self.image = image
        self.isShowingAlert = isShowingAlert
    }
    
    func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    func loadImage() {
        Task {
            guard let rawImage = try await pickerItem?.loadTransferable(type: Data.self) else { return }
            let uiImage = UIImage(data: rawImage)
            image = Image(uiImage: uiImage!)
        }
        
    }
    
    func checkIsNameFilled() -> Bool {
        isShowingNameWarning = false
        guard !name.isEmpty else {
            isShowingNameWarning = true
            return false
        }
        return true
    }
    
    func saveToContext() {
        guard checkIsNameFilled() else { return }
        dataSource.appendItem(item:StoredItem(name: name, itemDescription: itemDescription.isEmpty ? nil : itemDescription))
    }
    
    func askToSave() {
        guard checkIsNameFilled() else { return }
        isShowingAlert = true
    }
    
}
