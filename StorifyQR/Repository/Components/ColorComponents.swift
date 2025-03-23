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

enum TagColors: String, Codable {
    case tagPurple = "tagPurple"
    case tagRed = "tagRed"
    case tagOrange = "tagOrange"
    case tagYellow = "tagYellow"
    case tagGreen = "tagGreen"
    case tagBlue = "tagBlue"
}

struct ColorComponents {
    
    static func decodeTagColor(colorString: String) -> Color {
        switch colorString {
        case "tagPurple":
            return Color.tagPurple
        case "tagRed":
            return Color.tagRed
        case "tagOrange":
            return Color.tagOrange
        case "tagYellow":
            return Color.tagYellow
        case "tagGreen":
            return Color.tagGreen
        case "tagBlue":
            return Color.tagBlue
        default:
            return Color.gray
        }
    }

    static func encodeTagColor(color: Color) -> String {
        switch color {
        case Color.tagPurple:
            return "tagPurple"
        case Color.tagRed:
            return "tagRed"
        case Color.tagOrange:
            return "tagOrange"
        case Color.tagYellow:
            return "tagYellow"
        case Color.tagGreen:
            return "tagGreen"
        case Color.tagBlue:
            return "tagBlue"
        default:
            return "gray"
        }
    }
}
