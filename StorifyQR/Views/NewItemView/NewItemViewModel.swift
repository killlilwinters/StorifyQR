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
    
    static let saveButtonStyle = LinearGradient(colors: [.blue, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing)
    
    let mapView = MapView(userCustomLocation: nil)
    
    var mlModelTag = Tag(title: "ExampleML", colorComponent: ColorComponents.fromColor(.blue))
    
    func saveToContext() {
        guard checkIsNameFilled() else { return }
        let itemsLocation = mapView.viewModel.getCurrentLocation()
        let newItem = StoredItem(photo: photoData, name: name, itemDescription: itemDescription.isEmpty ? nil : itemDescription, location: itemsLocation)
        dataSource.appendItem(item: newItem)
//        tags.insert(mlModelTag, at: 0) // MLModel computed tag insertion
//        Above commented code causes duplicate values and crashes the app
//        TODO: Find a better way to insert MLModel result tag
        dataSource.appendTagToItem(item: newItem, tags: tags)
    }
    
}
