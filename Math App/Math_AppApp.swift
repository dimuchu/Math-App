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
    @AppStorage("appearance") private var appearanceRaw: String = AppAppearance.system.rawValue
    @AppStorage("hasUserSelectedAppearance") private var hasUserSelectedAppearance = false

    private var preferredAppColorScheme: ColorScheme? {
        guard hasUserSelectedAppearance else { return nil }
        return (AppAppearance(rawValue: appearanceRaw) ?? .system).colorScheme
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(preferredAppColorScheme)
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
