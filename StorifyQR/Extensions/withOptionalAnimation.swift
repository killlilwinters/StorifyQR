//
//  withOptionalAnimation.swift
//  StorifyQR
//
//  Created by Maks Winters on 25.02.2024.
//
// https://www.hackingwithswift.com/books/ios-swiftui/supporting-specific-accessibility-needs-with-swiftui
//

import UIKit
import SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}

extension View {
    func optionalTrnsition(transition: AnyTransition) -> some View {
        modifier(OptionalTranstion(transition: transition))
    }
}

struct OptionalTranstion: ViewModifier {
    let transition: AnyTransition
    
    func body(content: Content) -> some View {
        if UIAccessibility.isReduceMotionEnabled {
            content
        } else {
            content
                .transition(transition)
        }
    }
    
}
