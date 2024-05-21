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
    @MainActor private let dataSource = TagDataSource.shared
    
    var saveTo: (Tag) -> Void
    
    var rows: [[Tag]] = []
    var tags = [Tag]()
    var tagText = ""
    var tagTextLength = 10
    
    var tagToDelete: Tag?
    var isShowingDeleteAlert = false
    
    var selectedColor = Color.tagRed
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
        let newTag = Tag(title: tagText, tagColor: selectedColor)
        dataSource.appendItem(tag: newTag)
        getTags()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tagText = ""
        }
    }
    
    func requestDelete(tag: Tag) {
        print("Requested deletion")
        tagToDelete = tag
        isShowingDeleteAlert = true
    }
    
    func deleteTag(tag: Tag) {
        dataSource.removeItem(tag)
        getTags()
    }
    
    func fetchTags() {
        tags = dataSource.fetchItems().filter { $0.isMLSuggested == false}
    }
    
    func sendMLTagOut(title: String) {
        if let matchingTag = tags.first(where: { $0.title == title }) {
            print("Found tag: \(matchingTag.title)")
            saveTo(matchingTag)
        } else {
            print("Tag not found with title: \(title), creating a new one instead")
            let newTag = Tag(title: title, isMLSuggested: true, tagColor: .gray)
            saveTo(newTag)
        }
    }
    
    init(saveTo: @escaping (Tag) -> Void) {
        self.saveTo = saveTo
        fetchTags()
        getTags()
    }
}
