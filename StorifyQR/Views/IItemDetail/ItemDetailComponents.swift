//
//  ItemDetailComponents.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//

import Foundation
import SwiftUI

struct ActionButtons: View {
    var body: some View {
        HStack {
            Group {
                Button {
                    // Editing action
                } label: {
                    ActionButton(sfImage: "pencil", buttonText: "Edit", color: .blue)
                }
                Button {
                    // Sharing button
                } label: {
                    ActionButton(sfImage: "square.and.arrow.up", buttonText: "Share", color: .green)
                }
                Button(role: .destructive) {
                    // Delete button
                } label: {
                    ActionButton(sfImage: "trash", buttonText: "Delete", color: .red)
                }
            }
            .buttonStyle(.bordered)
            .clipShape(.capsule)
        }
        .padding(.top)
        .padding(.horizontal)
    }
}
