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
        super.init(item: item)
    }
    
    func saveChanges() {
        let itemDescChecked = itemDescription.isEmpty ? nil : itemDescription
        let itemsLocation = mapView.viewModel.getCurrentLocation()
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
