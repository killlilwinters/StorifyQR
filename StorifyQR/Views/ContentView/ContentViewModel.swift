//
//  ContentViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 15.01.2024.
//
// https://www.youtube.com/watch?v=-Tx5BLhcdEk
//
// https://stackoverflow.com/a/28781171
//

import Foundation
import SwiftUI

struct Tags: Codable {
    var tags: [Tag]
}

@Observable
final class ContentViewModel {
    static let imageConverter = ImageCoverter()
    
    @MainActor let dataSource = StoredItemDataSource.shared
    @MainActor let tagDataSource = TagDataSource.shared
    
    var storedItems = [StoredItem]()
    var filteredItems: [StoredItem] {
        guard !searchText.isEmpty else { return storedItems }
            let filteredItems = storedItems.compactMap {
                let itemContainsQuery = $0.name.range(of: searchText, options: .caseInsensitive) != nil
                return itemContainsQuery ? $0 : nil
            }
        return filteredItems
    }
    var tags = [Tag]()
    var selectedTag: Tag? { didSet {
        fetchFiltered()
    }}
    var searchText = ""
    var isSearching = false
    
    // Items unavailable content unavailable views
    var isShowingNothingFoundCUV: Bool {
        isSearching && filteredItems.isEmpty && !storedItems.isEmpty
    }
    var isShowingNoItemsCUV: Bool {
        storedItems.isEmpty && selectedTag == nil
    }
    var isShowingNoItemsForTagCUV: Bool {
        storedItems.isEmpty && selectedTag != nil
    }
    
    var path = NavigationPath()
    
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
            
            let decoded: StoredItem = try Bundle.main.decode(success)
            let rawTags: Tags = try Bundle.main.decode(success)
            
            let taglessObject = StoredItem(photo: decoded.photo, name: decoded.name, itemDescription: decoded.itemDescription, location: decoded.location)
            
            importItem = taglessObject
            importItemTags = rawTags.tags
            
            importingAlert = true
        } catch {
            errorMessage = error.localizedDescription
            print(error)
            errorAlert = true
        }
    }
    
    func getImage(item: StoredItem) -> Image? {
        return item.photo.flatMap { Image(data: $0) }
    }
    
    func fetchItems() {
        storedItems = dataSource.fetchItems()
        tags = tagDataSource.fetchItems().sorted { $0.isMLSuggested && !$1.isMLSuggested }
    }
    
    func filterTag(tag: Tag) {
        if tag == selectedTag {
            fetchItems()
            selectedTag = nil
        } else {
            selectedTag = tag
        }

    }
    
    func fetchFiltered() {
        guard selectedTag != nil else { return }
        do {
            storedItems = try dataSource.fetchItems().filter(
                #Predicate<StoredItem>{
                    $0.tags.contains(selectedTag!)
                }
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func processImport(result: Result<URL, any Error>) {
        switch result {
        case .success(let success):
            saveImport(success)
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
}
