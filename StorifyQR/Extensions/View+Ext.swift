//
//  View+Ext.swift
//  StorifyQR
//
//  Created by Maks Winters on 23.03.2025.
//
// https://stackoverflow.com/a/57715771/23215434
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

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

//MARK: - Error Alert
extension View {
    func simpleErrorAlert(message errorMessage: String, isPresented: Binding<Bool>) -> some View {
        self
            .alert("There was an error", isPresented: isPresented) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
    }
}
