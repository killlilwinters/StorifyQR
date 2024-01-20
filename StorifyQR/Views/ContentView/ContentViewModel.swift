//
//  ContentViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 15.01.2024.
//

import Foundation
import SwiftUI

struct Tags: Codable {
    var tags: [Tag]
}

@Observable
final class ContentViewModel {
    static let imageConverter = ImageCoverter()
    let dataSource: StoredItemDataSource
    let tagDataSource = TagDataSource.shared
    
    var storedItems = [StoredItem]()
    
    var path: NavigationPath
    
    var importingData = false
    
    var importingAlert = false
    var errorAlert = false
    var errorMessage = ""
    
    var importItem: StoredItem?
    var importItemTags: [Tag]?
    
    func saveItem() {
        dataSource.appendItem(item: importItem!)
        dataSource.appendTagToItem(item: importItem!, tags: importItemTags!)
        fetchItems()
    }
    
    func saveImport(_ success: URL) {
        do {
            let decoder = JSONDecoder()
            
            let data = try Data(contentsOf: success)
            let decoded = try decoder.decode(StoredItem.self, from: data)
            let rawTags = try decoder.decode(Tags.self, from: data)
            
            let taglessObject = StoredItem(photo: decoded.photo, name: decoded.name, itemDescription: decoded.itemDescription, location: decoded.location)
            
            importItem = taglessObject
            importItemTags = rawTags.tags
            
            importingAlert = true
        } catch {
            errorMessage = error.localizedDescription
            errorAlert = true
        }
    }
    
    func fetchItems() {
        storedItems = dataSource.fetchItems()
    }
    
    init(dataSource: StoredItemDataSource = StoredItemDataSource.shared, path: NavigationPath = NavigationPath()) {
        self.dataSource = dataSource
        self.path = path
    }
}
