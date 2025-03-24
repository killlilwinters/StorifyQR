//
//  SheetPresentation.swift
//  StorifyQR
//
//  Created by Maks Winters on 24.03.2025.
//

import Foundation

enum SheetPresentation: Identifiable {
    case onboardingView
    case addTagView(AbstractClassifier, saveTo: (Tag) -> Void)
    
    var id: Int {
        switch self {
        case .onboardingView:
            return 0
        case .addTagView:
            return 1
        }
    }
}
