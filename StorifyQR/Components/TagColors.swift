//
//  TagColors.swift
//  StorifyQR
//
//  Created by Maks Winters on 15.01.2024.
//
// https://www.hackingwithswift.com/forums/swiftui/resolved-colors-and-swiftdata/22483
//

import Foundation
import SwiftUI

import SwiftUI

enum TagColors: String, Codable, CaseIterable {
    
    case tagPurple, tagRed, tagOrange, tagYellow, tagGreen, tagBlue, tagDefault
    case gray // Tag color placeholder for ML tags so it does not crash the app

    var color: Color {
        switch self {
        case .tagPurple:  return .tagPurple
        case .tagRed:     return .tagRed
        case .tagOrange:  return .tagOrange
        case .tagYellow:  return .tagYellow
        case .tagGreen:   return .tagGreen
        case .tagBlue:    return .tagBlue
        case .tagDefault: return .tagDefault
        case .gray:       return .gray
        }
    }

    static func decodeTagColor(from colorString: String) -> Color {
        TagColors(rawValue: colorString)?.color ?? .gray
    }

    static func encodeTagColor(from color: Color) -> String {
        allCases.first(where: { $0.color == color })?.rawValue ?? "gray"
    }

    static func isColorInTagColors(_ color: Color) -> Bool {
        allCases.contains { $0.color == color }
    }
}

