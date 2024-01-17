//
//  PreviewContainer.swift
//  StorifyQR
//
//  Created by Maks Winters on 08.01.2024.
//

import Foundation
import SwiftData

struct PreviewContainer {
    static let item = StoredItem(name: "StoredItem", itemDescription: "Important: If you attempt to create a model object without first having created a container for that object, your preview will crash. If you do all that and don't use the modelContainer() modifier to send your container into SwiftUI, running any code using the modelContext environment key will also crash your preview.", location: nil)
    let container: ModelContainer!
    init(_ types: [any PersistentModel.Type], isStoredInMemoryOnly: Bool = true) {
        let schema = Schema (types)
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        self.container = try! ModelContainer(for: schema, configurations: config)
    }
}
