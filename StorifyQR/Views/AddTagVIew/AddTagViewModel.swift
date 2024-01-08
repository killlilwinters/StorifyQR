//
//  AddTagViewModel.swift
//  StorifyQR
//
//  Created by Maks Winters on 09.01.2024.
//

import Foundation

@Observable
final class AddTagViewModel {
    var title = ""
    var saveTo: (Tag) -> Void
    
    func makeTag() -> Tag? {
        guard title != "" else { return nil }
        return Tag(title: title)
    }
    
    init(title: String = "", saveTo: @escaping (Tag) -> Void) {
        self.title = title
        self.saveTo = saveTo
    }
}
