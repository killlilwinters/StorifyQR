//
//  ViewComponents.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//

import Foundation
import SwiftUI

struct ContentPad: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundStyle(Color(.contentPad))
            content
                .padding()
        }
    }
}

struct ActionButton: View {
    
    let sfImage: String?
    let buttonText: String
    let color: Color
    
    var body: some View {
        HStack {
            if sfImage != nil {
                Image(systemName: sfImage!)
                    .foregroundStyle(color)
                    .frame(width: 20, height: 20)
            }
            Text(buttonText)
                .foregroundStyle(.themeRelative)
        }
    }
}
