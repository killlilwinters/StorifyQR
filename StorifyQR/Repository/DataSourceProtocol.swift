//
//  DataSourceProtocol.swift
//  StorifyQR
//
//  Created by Maks Winters on 07.06.2024.
//
// Useful: https://www.donnywals.com/whats-the-difference-between-any-and-some-in-swift-5-7/
//
// https://forums.swift.org/t/swiftdata-predicate-does-not-handle-protocol-witness/68256
//
// https://www.youtube.com/watch?v=4XpHOJr9Z7I&t=346s
//
// https://www.youtube.com/watch?v=SPhATsEQR74
//
// Combine: https://www.youtube.com/live/-NDFLP7Aqeg?si=mD36_3UYMG3xVdcP
//

import SwiftData
import Combine

// MARK: - Enums
enum DBNotification {
    case update
}

@MainActor
enum DBNotificationCenter {
    static let publisher = Publishers.Merge(StoredItemDataSource.shared.dbPublisher, TagDataSource.shared.dbPublisher)
}

// MARK: - Protocols
protocol SwiftDataItem: Codable, PersistentModel { }

protocol DataSource {
    
    associatedtype Item: SwiftDataItem
    
    var dbPublisher: PassthroughSubject<DBNotification, Never> { get }
    
    func appendItem(_ item: Item)
    
    func fetchItems() -> [Item]
    
    func removeItem(_ item: Item)
    
}
