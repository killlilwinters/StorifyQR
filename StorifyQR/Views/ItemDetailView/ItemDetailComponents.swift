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
#warning("Implement coordinator to fix updating location in the background since it is not necessary in detail view - it is caused by this navlink")
                Button {
                    coordinator.push(.editView(viewModel.item))
                } label: {
                    ActionButton(sfImage: "pencil", buttonText: Text("Edit"), color: .blue)
                }
                ShareLink(item: viewModel.item,
                          preview: SharePreview(viewModel.item.name,
                          image: viewModel.image ?? Image(systemName: "shippingbox.fill"))) {
                    ActionButton(sfImage: "square.and.arrow.up", buttonText: Text("Share"), color: .green)
                }
                Button(role: .destructive) {
                    viewModel.isShowingAlert = true
                } label: {
                    ActionButton(sfImage: "trash", buttonText: Text("Delete"), color: .red)
                }
            }
            .buttonStyle(.bordered)
            .clipShape(.capsule)
        }
        .padding(.top)
        .padding(.horizontal)
    }
}
