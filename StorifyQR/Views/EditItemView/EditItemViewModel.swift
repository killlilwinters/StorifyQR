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
final class EditItemViewModel {
    
    static let saveButtonStyle = LinearGradient(colors: [.blue, .yellow], startPoint: .bottomLeading, endPoint: .topTrailing)
    
    @ObservationIgnored
    private let dataSource: StoredItemDataSource
    
    let mapView = MapView()
    
    let item: StoredItem
    
    var name = ""
    var isShowingNameWarning = false
    var itemDescription = ""
    
    var pickerItem: PhotosPickerItem?
    var photoData: Data?
    var image: Image?
    
    var tags = [Tag]()
    
    var isShowingSheet = false
    var isShowingAlert = false
    
    init(dataSource: StoredItemDataSource = StoredItemDataSource.shared,
         item: StoredItem,
         isShowingNameWarning: Bool = false,
         isShowingAlert: Bool = false) {
        self.dataSource = dataSource
        self.item = item
        self.name = item.name
        self.photoData = item.photo
        self.itemDescription = item.itemDescription ?? ""
        self.tags = item.tags
        if let itemsPhoto = item.photo {
            self.image = Image(data: itemsPhoto)
        }
    }
    
    func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    func loadImage() {
        Task {
            guard let rawImage = try await pickerItem?.loadTransferable(type: Data.self) else { return }
            let fullUIImage = UIImage(data: rawImage)
            photoData = fullUIImage?.jpeg(.low)
            let compressedUIImage = UIImage(data: photoData!)
            image = Image(uiImage: compressedUIImage!)
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
    
    func preloadValues() {
        name = item.name
        itemDescription = item.itemDescription ?? ""
        photoData = item.photo
        tags = item.tags
    }
    
    func saveChanges() {
        let itemDescChecked = itemDescription.isEmpty ? nil : itemDescription
        let itemsLocation = mapView.viewModel.appendLocation()
        dataSource.editItem(item: item, photo: photoData, name: name, itemDescription: itemDescChecked, tags: tags, location: itemsLocation)
    }
    
    func appendLocation() -> Coordinate2D? {
        if mapView.viewModel.isIncludingLocation {
            let location = mapView.viewModel.rawLocation
            return Coordinate2D(latitude: location.latitude, longitude: location.longitude)
        } else {
            return nil
        }
    }
    
    func askToSave() {
        guard checkIsNameFilled() else { return }
        isShowingAlert = true
    }
    
}
