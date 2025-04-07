//
//  iPadScreenContainer.swift
//  StorifyQR
//
//  Created by Maks Winters on 05.02.2024.
//

import SwiftUI

struct iPadScreenContainer: ViewModifier {
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            content
                .containerRelativeFrame(.horizontal) { width, axis in
                    width * 0.6
                }
        } else {
            content
        }
    }
}
