//
//  Coordinator.swift
//  StorifyQR
//
//  Created by Maks Winters on 23.03.2025.
//
//  https://www.youtube.com/watch?v=aaLRST7tHFQ
//

import SwiftUI

@Observable
final class Coordinator {
    
    var path = NavigationPath()
    
    func push(_ destination: ViewDestination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popAll() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(destination: ViewDestination) -> some View {
        switch destination {
        case .scannerView:
            QRScannerView()
                .environment(self)
        case .newItemView:
            NewItemView()
                .environment(self)
        case .detailView(let item):
            ItemDetailView(item: item)
                .environment(self)
        case .editView(let item):
            EditItemView(item: item)
                .environment(self)
        }
    }
    
}
