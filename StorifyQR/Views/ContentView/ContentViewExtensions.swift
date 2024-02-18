//
//  ContentViewExtensions.swift
//  StorifyQR
//
//  Created by Maks Winters on 18.02.2024.
//
// https://stackoverflow.com/a/57715771/23215434
//

import SwiftUI

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
