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

struct StyledButtonComponent<Style: ShapeStyle>: View {
    
    let title: String
    var foregroundStyle: Style
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(foregroundStyle)
            .overlay (
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
            )
            .frame(height: 50)
    }
}
