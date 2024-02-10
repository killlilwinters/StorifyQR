//
//  StoredItemDataSource.swift
//  StorifyQR
//
//  Created by Maks Winters on 05.01.2024.
//
// https://dev.to/jameson/swiftui-with-swiftdata-through-repository-36d1
//

import Foundation
import SwiftData

final class StoredItemDataSource {
    let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = StoredItemDataSource()

    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: StoredItem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: ProcessInfo.isOnPreview() ? true : false))
        self.modelContext = modelContainer.mainContext
    }
    
    func appendTagToItem(item: StoredItem, tags: [Tag]) {
        item.tags = tags
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func appendItem(item: StoredItem) {
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func editItem(item: StoredItem, 
                  photo: Data?,
                  name: String,
                  itemDescription: String?,
                  tags: [Tag],
                  location: Coordinate2D?) 
    {
        item.photo = photo
        item.name = name
        item.itemDescription = itemDescription
        item.location = location
        item.tags = tags
        do {
            try modelContext.save()
        } catch {
            fatalError("\(error)")
        }
    }

    func fetchItems() -> [StoredItem] {
        do {
            return try modelContext.fetch(FetchDescriptor<StoredItem>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getItem(itemUUID: UUID) -> StoredItem? {
        if let item = fetchItems().first(where: {$0.id == itemUUID}) {
           return item
        } else {
           return nil
        }
    }

    func removeItem(_ item: StoredItem) {
        modelContext.delete(item)
    }
}
