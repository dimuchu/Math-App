//
//  Math_AppApp.swift
//  Math App
//
//  Created by Дмитрий on 25.03.2026.
//

import SwiftUI
import SwiftData

@main
struct Math_AppApp: App {
    private let settings = AppSettings.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(settings.colorScheme)
        }
        .modelContainer(ModelContainer.shared)
    }
}

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}
