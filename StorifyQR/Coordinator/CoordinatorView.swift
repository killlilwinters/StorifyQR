//
//  CoordinatorView.swift
//  StorifyQR
//
//  Created by Maks Winters on 23.03.2025.
//

import SwiftUI

struct CoordinatorView: View {
    @Environment(Coordinator.self) var coordinator
    @Binding var selectedItem: StoredItem?
    
    @AppStorage("LANGUAGE") var savedLanguage = ""
    @AppStorage("ONBOARDING") var showOnboarding = true
    
    var body: some View {
        @Bindable var coordinator = coordinator
        NavigationStack(path: $coordinator.path) {
            VStack {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    iPadLayout
                } else if UIDevice.current.userInterfaceIdiom == .phone {
                    iPhoneLayout
                }
            }
                .environment(coordinator)
                .onAppear {
                    checkForLangChange()
                    showOnboardingIfNeeded()
                }
                .navigationDestination(for: ViewDestination.self) { destination in
                    coordinator.build(destination: destination)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(presentation: sheet)
                        .onDisappear {
                            // For the purposes of keeping the code simple this solution was left
                            // But it causes the showOnboarding to become false
                            // upon removing the app straight from the app switcher
                            if sheet.id == 0 { showOnboarding = false }
                        }
                }
        }
    }
    
    var iPadLayout: some View {
        Group {
            if let selectedItem {
                ItemDetailView(item: selectedItem)
            } else {
                ContentUnavailableView("Select an item", systemImage: "shippingbox.fill")
            }
        }
    }
    
    var iPhoneLayout: some View {
        ItemListView(selectedItem: .constant(nil))
    }
    
    func showOnboardingIfNeeded() {
        guard showOnboarding else { return }
        coordinator.push(.onboardingView)
    }
    
    func checkForLangChange() {
        let languageCode = Locale.current.language.languageCode?.identifier
        if savedLanguage != languageCode {
            guard let sl = languageCode else { return }
            savedLanguage = sl
            showOnboarding = true
        }
    }
    
}

#Preview {
    CoordinatorView(selectedItem: .constant(nil))
        .environment(Coordinator())
}
