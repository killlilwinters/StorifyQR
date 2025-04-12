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
    
    var path = [ViewDestination]()
    var sheet: SheetPresentation?
    
    func push(_ destination: ViewDestination) {
        path.append(destination)
    }
    
    func nonRepeatingPush(_ destination: ViewDestination) {
        path.last == destination ? () : push(destination)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popAll() {
        path.removeLast(path.count)
    }
    
    func push(_ presentation: SheetPresentation) {
        sheet = presentation
    }
    
    func dismissSheet() {
        sheet = nil
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
    
    @ViewBuilder
    func build(presentation: SheetPresentation) -> some View {
        switch presentation {
        case .onboardingView:
            OnboardingView()
                .environment(self)
        case .addTagView(let classifier, let completion):
            AddTagView(classifierInstance: classifier, saveTo: completion)
                .presentationDetents([.medium, .large])
                .environment(self)
        }
    }
    
}
