//
//  ItemDetailComponents.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//

import Foundation
import SwiftUI

extension ItemDetailView {
    var actionButtons: some View {
        HStack {
            Group {
                Button {
                    // Editing action
                } label: {
                    ActionButton(sfImage: "pencil", buttonText: "Edit", color: .blue)
                }
                ShareLink(item: viewModel.item, preview: SharePreview(viewModel.item.name, image: "globe")){
                    ActionButton(sfImage: "square.and.arrow.up", buttonText: "Share", color: .green)
                }
                Button(role: .destructive) {
                    viewModel.isShowingAlert = true
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
