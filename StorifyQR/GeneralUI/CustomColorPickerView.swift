//
//  CustomColorPickerView.swift
//  StorifyQR
//
//  Created by Maks Winters on 15.01.2024.
//

import SwiftUI

struct CustomColorPickerView: View {
    @Binding var selectedColor: Color
    let colors: [Color] = [.tagPurple,
                           .tagRed,
                           .tagOrange,
                           .tagYellow,
                           .tagGreen,
                           .tagBlue]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        self.selectedColor = color
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(Color.primary, lineWidth: self.selectedColor == color ? 3 : 0)
                            )
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    CustomColorPickerView(selectedColor: .constant(Color.red))
}
