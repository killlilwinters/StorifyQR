//
//  TagDataSource.swift
//  StorifyQR
//
//  Created by Maks Winters on 15.01.2024.
//
// https://forums.developer.apple.com/forums/thread/733093
//

import Combine
import SwiftData

final class TagDataSource: DataSource {
    var dbPublisher = PassthroughSubject<DBNotification, Never>()
    
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = TagDataSource()

    @MainActor
    private init() {
        self.modelContainer = StoredItemDataSource.shared.modelContainer
        self.modelContext = modelContainer.mainContext
    }

    func appendItem(_ item: Tag) {
        modelContext.insert(item)
        do {
            try modelContext.save()
            dbPublisher.send(.update)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func fetchItems() -> [Tag] {
        do {
            return try modelContext.fetch(FetchDescriptor<Tag>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func removeItem(_ item: Tag) {
        modelContext.delete(item)
        dbPublisher.send(.update)
    }
}
