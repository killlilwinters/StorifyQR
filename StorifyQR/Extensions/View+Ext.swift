//
//  View+Ext.swift
//  StorifyQR
//
//  Created by Maks Winters on 23.03.2025.
//

import SwiftUI

extension View {
    func optionalTrnsition(transition: AnyTransition) -> some View {
        modifier(OptionalTranstion(transition: transition))
    }
}

extension View {
    func makeiPadScreenCompatible() -> some View {
        modifier(iPadScreenContainer())
    }
}
