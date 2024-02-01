//
//  DateConverter.swift
//  StorifyQR
//
//  Created by Maks Winters on 02.01.2024.
//

import Foundation

struct DateConverter {
    static let formatter = DateFormatter()
    let date: Date
    
    func format() -> String {
        let formatter = DateConverter.formatter
        formatter.dateStyle = .medium
        let finalDate = formatter.string(from: date)
        return finalDate
    }
    
    func currentDateTimeString() -> String {
        let formatter = DateConverter.formatter
        formatter.dateFormat = "MM-dd-yyyy-HH:mm"
        let stringDate = formatter.string(from: date)
        return stringDate
    }
}
