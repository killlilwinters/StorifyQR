//
//  ViewDestination.swift
//  StorifyQR
//
//  Created by Maks Winters on 23.03.2025.
//

import Foundation

enum ViewDestination: Hashable {
    case newItemView
    case scannerView
    case detailView(StoredItem)
    case editView(StoredItem)
}
