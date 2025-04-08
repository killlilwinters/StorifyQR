//
//  TagsCarrousel.swift
//  StorifyQR
//
//  Created by Maks Winters on 08.04.2025.
//

import SwiftUI

struct TagsCarrousel: View {
    
    @Binding var isSearching: Bool
    @Binding var searchText: String
    @Binding var selectedTag: Tag?
    
    let tags: [Tag]
    let performFilter: (Tag) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                //  if viewModel.isSearching {
                //       SearchBar(searchText: $viewModel.searchText)
                //             .padding()
                //  }
                InlineSearchBar(
                    isSearching: $isSearching,
                    searchText: $searchText
                )
                .padding(.leading)
                
                ForEach(tags) { tag in
                    let isSelected = tag == selectedTag
                    let trailingPadding: CGFloat = tags.last == tag ? 15 : 0
                    
                    TagView(tag: tag)
                        .onTapGesture {
                            performFilter(tag)
                        }
                        .overlay (
                            Capsule()
                                .stroke(lineWidth: isSelected ? 3 : 0)
                        )
                        .padding(.horizontal, 1)
                        .padding(.vertical, 2)
                        .padding(.trailing, trailingPadding)
                    
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.vertical)
    }
}

#Preview {
    TagsCarrousel(
        isSearching: .constant(true),
        searchText: .constant("Some test text"),
        selectedTag: .constant(Tag(title: "Tag", tagColor: .tagBlue)),
        tags: [],
        performFilter: { tag in }
    )
}
