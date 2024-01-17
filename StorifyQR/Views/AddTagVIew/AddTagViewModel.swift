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
    private let dataSource: TagDataSource
    
    var saveTo: (Tag) -> Void
    
    var rows: [[Tag]] = []
    var tags = [Tag]()
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
        tags = dataSource.fetchItems()
    }
    
    func limitTextField() {
        if tagText.count > tagTextLength {
            tagText = String(tagText.prefix(tagTextLength))
        }
    }
    
    func addTag() {
        print("Adding a tag")
        guard !tagText.isEmpty else { return }
        let newTag = Tag(title: tagText, colorComponent: ColorComponents.fromColor(selectedColor))
        dataSource.appendItem(tag: newTag)
        getTags()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tagText = ""
        }
    }
    
    func removeTag(tag: Tag) {
        dataSource.removeItem(tag)
        getTags()
    }
    
    init(dataSource: TagDataSource = TagDataSource.shared, saveTo: @escaping (Tag) -> Void) {
        self.dataSource = dataSource
        self.saveTo = saveTo
        self.tags = dataSource.fetchItems()
        getTags()
    }
}
