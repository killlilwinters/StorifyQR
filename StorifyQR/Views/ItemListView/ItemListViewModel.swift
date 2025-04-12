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
// https://stackoverflow.com/questions/49054485/file-couldn-t-be-opened-because-you-don-t-have-permission-to-view-it-error
//

import Combine
import SwiftUI

@Observable @MainActor
final class ItemListViewModel {
    
    struct Tags: Codable {
        var tags: [Tag]
    }
    
    static let imageConverter = ImageCoverter()
    
    let dataSource = StoredItemDataSource.shared
    let tagDataSource = TagDataSource.shared
    
    var storedItems = [StoredItem]()
    
    var searchText = ""
    var isSearching = false
    var filteredItems: [StoredItem] {
        guard !searchText.isEmpty else { return storedItems }
        
        return storedItems.filter {
            $0.name.localizedStandardContains(searchText)
        }
    }
    
    var tags = [Tag]()
    var selectedTag: Tag? {
        didSet { DispatchQueue.main.async { self.fetchFiltered() } }
    }
    
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
    
    // Import
    var importItem: StoredItem?
    var importItemTags: [Tag]?
    
    var importingData = false
    
    var importingAlert = false
    var isPresentingError = false
    var errorMessage = ""
    
    // Combine
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        subscribeToDBUpdates()
    }
    
    func subscribeToDBUpdates() {
        dataSource.dbPublisher
            .sink { newValue in
                if newValue == .update {
                    self.fetchItems()
                }
            }
            .store(in: &subscriptions)
    }
    
    func saveItem() {
        dataSource.appendItem(importItem!)
        dataSource.appendTagToItem(item: importItem!, tags: importItemTags!)
        fetchItems()
    }
    
    func saveImport(_ success: URL) {
        do {
            
            let decoded: StoredItem = try Bundle.main.decode(success)
            let rawTags: Tags = try Bundle.main.decode(success)
            
            let taglessObject = StoredItem(id: decoded.id, photo: decoded.photo, name: decoded.name, itemDescription: decoded.itemDescription, location: decoded.location)
            
            importItem = taglessObject
            importItemTags = rawTags.tags
            
            importingAlert = true
        } catch {
            errorMessage = error.localizedDescription
            print(error)
            isPresentingError = true
        }
    }
    
    func fetchItems() {
        print("Fetching items")
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
        guard let selectedTag else { return }
        do {
            storedItems = try dataSource.fetchItems().filter(
                #Predicate<StoredItem>{
                    $0.tags.contains(selectedTag)
                }
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func processImport(result: Result<URL, any Error>) {
        switch result {
        case .success(let success):
            guard success.startAccessingSecurityScopedResource() else {
                return
            }
            saveImport(success)
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
}
