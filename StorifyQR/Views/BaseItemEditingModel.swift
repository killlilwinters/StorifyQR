//
//  BaseItemEditingModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 01.02.2024.
//

import SwiftUI
import PhotosUI

@Observable
class BaseItemEditing {
    let classifier = AbstractClassifier()
    
    @ObservationIgnored
    @MainActor let dataSource = StoredItemDataSource.shared
    
    var name = ""
    var isShowingNameWarning = false
    var itemDescription = ""
    var location: CLLocationCoordinate2D?
    
    var pickerItem: PhotosPickerItem?
    var photoData: Data?
    var image: Image?
    
    // Save alert
    var isShowingAlert = false
    
    // Tag manipulation alert
    var isShowingTagAlert = false
    
    var tags = [Tag]()
    
    // Input
    let maxNameLenght = 30
    let maxDescLenght = 300
    var nameCharactersLeft: String {
        "\(name.count) / \(maxNameLenght)"
    }
    var descCharactersLeft: String {
        "\(itemDescription.count) / \(maxDescLenght)"
    }
    
    init(item: StoredItem? = nil) {
        self.name = item?.name ?? ""
        self.itemDescription = item?.itemDescription ?? ""
        self.photoData = item?.photo
        self.location = item?.location?.getCLLocation() ?? nil
        self.image = item?.photo != nil ? Image(data: item!.photo!) : nil
        self.tags = item?.tags ?? [Tag]()
    }
    
    func limitName() {
        name.limitTextField(limit: maxNameLenght)
    }
    func limitDescription() {
        itemDescription.limitTextField(limit: maxDescLenght)
    }
    
    func addTagToItem(tag: Tag) {
        guard !(tag.isMLSuggested && tags.contains(where: { $0.isMLSuggested })) else {
            isShowingTagAlert = true
            return
        }
        
        guard !tags.contains(where: { $0.title == tag.title }) else { return }
        
        if tag.isMLSuggested {
            tags.insert(tag, at: 0)
        } else {
            tags.append(tag)
        }
        
    }
    
    func loadImage() {
        Task {
            await ImageCoverter.shared.loadImage(pickerItem: pickerItem!) { photoData, image, error in
                if error == nil {
                    self.photoData = photoData
                    self.image = image
                    do {
                        try self.initializeDetection()
                    } catch {
                        print(error)
                    }
                } else {
                    print(error ?? "Unknown error")
                }
            }
        }
    }
    
    private func initializeDetection() throws {
        guard let photoData else { throw Errors.noImageData }
        
        guard let uiImage = UIImage(data: photoData) else { throw Errors.ivalidImageData }
        
        do { try classifier.detect(uiImage: uiImage) } catch { throw error }
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
    
    func askToSave() {
        guard checkIsNameFilled() else { return }
        isShowingAlert = true
    }
    
    func removeTag(at index: Int) {
        tags.remove(at: index)
    }
    
}
