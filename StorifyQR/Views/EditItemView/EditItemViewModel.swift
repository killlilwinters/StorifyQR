//
//  EditItemViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 31.01.2024.
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
final class EditItemViewModel: BaseItemEditing {
    
    static let saveButtonStyle = LinearGradient(colors: [.blue, .green], startPoint: .bottomLeading, endPoint: .topTrailing)
    
    let mapView = MapView()
    
    let item: StoredItem
    
    init(item: StoredItem,
         isShowingNameWarning: Bool = false,
         isShowingAlert: Bool = false) {
        self.item = item
        var itemsImage: Image?
        if let itemsPhoto = item.photo {
            itemsImage = Image(data: itemsPhoto)
        }
        super.init(name: item.name, itemDescription: item.itemDescription ?? "", photoData: item.photo, image: itemsImage, tags: item.tags)
    }
    
    func saveChanges() {
        let itemDescChecked = itemDescription.isEmpty ? nil : itemDescription
        let itemsLocation = mapView.viewModel.appendLocation()
        dataSource.editItem(item: item, photo: photoData, name: name, itemDescription: itemDescChecked, tags: tags, location: itemsLocation)
    }
    
    func checkLocation() {
        if item.location != nil {
            mapView.viewModel.isIncludingLocation = true
        }
    }
    
    func removeTag(at index: Int) {
        tags.remove(at: index)
    }
    
}
