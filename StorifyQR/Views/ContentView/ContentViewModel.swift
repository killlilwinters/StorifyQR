//
//  ContentViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 15.01.2024.
//

import Foundation
import SwiftUI

@Observable
final class ContentViewModel {
    static let imageConverter = ImageCoverter()
    let dataSource: StoredItemDataSource
    
    var storedItems = [StoredItem]()
    
    var path: NavigationPath
    
    func fetchItems() {
        storedItems = dataSource.fetchItems()
    }
    
    init(dataSource: StoredItemDataSource = StoredItemDataSource.shared, path: NavigationPath = NavigationPath()) {
        self.dataSource = dataSource
        self.path = path
    }
}
