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
class NewItemViewModel: BaseItemEditing {
    
    let mapView = MapView(userCustomLocation: nil)
    
    @MainActor
    func saveToContext() {
        guard checkIsNameFilled() else { return }
        let itemsLocation = mapView.viewModel.getCurrentLocation()
        let newItem = StoredItem(id: UUID(), photo: photoData, name: name, itemDescription: itemDescription.isEmpty ? "No description." : itemDescription, location: itemsLocation)
        dataSource.appendItem(newItem)
        tags.sort()
        dataSource.appendTagToItem(item: newItem, tags: tags)
    }
    
}
