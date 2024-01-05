//
//  BackgroundUI.swift
//  StorifyQR
//
//  Created by Maks Winters on 04.01.2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Background<Content: View>: View {
    private var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Color(.background)
            .ignoresSafeArea()
            .overlay(content)
    }
}
