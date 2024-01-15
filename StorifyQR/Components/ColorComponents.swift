//
//  ColorComponents.swift
//  StorifyQR
//
//  Created by Maks Winters on 15.01.2024.
//
// https://www.hackingwithswift.com/forums/swiftui/resolved-colors-and-swiftdata/22483
//

import Foundation
import SwiftUI

struct ColorComponents: Codable {
    let red: Float
    let green: Float
    let blue: Float

    var getColor: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue))
    }

    static func fromColor(_ color: Color) -> ColorComponents {
        let resolved = color.resolve(in: EnvironmentValues())
        return ColorComponents(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue
        )
    }
}
