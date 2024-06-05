//
//  QRItemViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 05.06.2024.
//

import Foundation

@Observable
class QRItemViewModel {
    let item: StoredItem
    var removeCurrentItem: (StoredItem) -> Void
    
    var isShowingAlert = false
    
    init(
        item: StoredItem,
        removeCurrentItem: @escaping (StoredItem) -> Void
    ) {
        self.item = item
        self.removeCurrentItem = removeCurrentItem
    }
}
