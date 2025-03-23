//
//  Shape+Ext.swift
//  StorifyQR
//
//  Created by Maks Winters on 23.03.2025.
//

import SwiftUI

extension Shape {
    func scanningPad(proxy: GeometryProxy) -> some View {
        self
            .clipShape(
                .rect(
                    topLeadingRadius: 35,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 35
                )
            )
            .foregroundStyle(Color.background)
            .ignoresSafeArea()
            .frame(height: proxy.size.height / 4)
    }
}
