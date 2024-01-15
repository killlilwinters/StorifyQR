//
//  AddTagViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 09.01.2024.
//

import Foundation
import SwiftUI

@Observable
final class AddTagViewModel {
    
    @ObservationIgnored
    private let dataSource: StoredItemDataSource
    
    var saveTo: (Tag) -> Void
    
    var rows: [[Tag]] = []
// TODO: Fix unability to add tags
    var tags: [Tag] = [
        Tag(title: "XCode", colorComponent: ColorComponents.fromColor(.blue)),
        Tag(title: "IOS", colorComponent: ColorComponents.fromColor(.green)),
        Tag(title: "IOS App Development", colorComponent: ColorComponents.fromColor(.orange)),
        Tag(title: "Swift", colorComponent: ColorComponents.fromColor(.red)),
        Tag(title: "SwiftUI", colorComponent: ColorComponents.fromColor(.purple))
    ]
    var tagText = ""
    var tagTextLength = 10
    
    var selectedColor = Color.red
    var isShowingSelectior = false
    
    func getTags() {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        var totalWidth: CGFloat = 0
        
        let screenWidth = UIScreen.screenWidth - 10
        let tagSpaceing: CGFloat = 14 /*Leading Padding*/ + 30 /*Trailing Padding*/ + 6 + 6 /*Leading & Trailing 6, 6 Spacing*/
        
        if !tags.isEmpty {
            
            for index in 0..<tags.count {
                self.tags[index].size = tags[index].title.getSize()
            }
            
            tags.forEach { tag in
                
                totalWidth += (tag.size + tagSpaceing)
                
                if totalWidth > screenWidth {
                    totalWidth = (tag.size + tagSpaceing)
                    rows.append(currentRow)
                    currentRow.removeAll()
                    currentRow.append(tag)
                } else {
                    currentRow.append(tag)
                }
            }
            
            if !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow.removeAll()
            }
            
            self.rows = rows
        } else {
            self.rows = []
        }
        
    }
    
    func limitTextField() {
        if tagText.count > tagTextLength {
            tagText = String(tagText.prefix(tagTextLength))
        }
    }
    
    func addTag() {
        guard !tagText.isEmpty else { return }
        let newTag = Tag(title: tagText, colorComponent: ColorComponents.fromColor(selectedColor))
        tags.append(newTag)
        print(tags.last?.title ?? "None")
        getTags()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tagText = ""
        }
    }
    
    func removeTag(by title: String) {
        tags = tags.filter{ $0.title != title }
        getTags()
    }
    
    init(dataSource: StoredItemDataSource = StoredItemDataSource.shared, saveTo: @escaping (Tag) -> Void) {
        self.dataSource = dataSource
        self.saveTo = saveTo
        getTags()
    }
}
