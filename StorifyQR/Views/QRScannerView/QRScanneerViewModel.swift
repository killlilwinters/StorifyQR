//
//  QRScanneerViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 03.06.2024.
//

import Foundation

enum ScanErrors: Error {
    case insufficientQRCode
}

@Observable
class QRScanneerViewModel {
    @MainActor
    private let dataSource = StoredItemDataSource.shared
    
    var recognizedItems: [String] = []
    
    var itemToShow: Result<StoredItem, Error>?
    
    func updateItemToShow() {
        let currentItem = recognizedItems.last ?? ""
        itemToShow = findItemInDataSource(uuidString: currentItem)
    }
    
    private func findItemInDataSource(uuidString: String) -> Result<StoredItem, Error> {
        let storedItems = dataSource.fetchItems()
        
        if let matchedItem = storedItems.first(where: { $0.id.uuidString == uuidString }) {
            return .success(matchedItem)
        } else {
            return .failure(ScanErrors.insufficientQRCode)
        }
    }
}
