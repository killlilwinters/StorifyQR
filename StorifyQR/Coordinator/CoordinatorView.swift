//
//  CoordinatorView.swift
//  StorifyQR
//
//  Created by Maks Winters on 23.03.2025.
//

import SwiftUI

struct CoordinatorView: View {
    
    @Bindable var coordinator = Coordinator()
    
    @AppStorage("LANGUAGE") var savedLanguage = ""
    @AppStorage("ONBOARDING") var showOnboarding = true
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ContentView()
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
    CoordinatorView()
}
