import SwiftUI
import SwiftData

@Observable
@MainActor
final class SettingsViewModel {
    private let storageService: SwiftDataStorageService
    private let settings = AppSettings.shared

    var enabledOperations: Set<MathOperation> {
        get { settings.enabledOperations }
        set { settings.enabledOperations = newValue }
    }

    var difficulty: DifficultyRange {
        get { settings.difficulty }
        set { settings.difficulty = newValue }
    }

    var appearance: AppAppearance {
        get { settings.appearance }
        set { settings.appearance = newValue }
    }

    var hapticsEnabled: Bool {
        get { settings.hapticsEnabled }
        set { settings.hapticsEnabled = newValue }
    }

    var showResetConfirmation = false
    var showRetakeDiagnostic = false

    init(modelContext: ModelContext) {
        self.storageService = SwiftDataStorageService(modelContext: modelContext)
    }

    func toggleOperation(_ operation: MathOperation) {
        var ops = enabledOperations
        if ops.contains(operation) {
            // Don't allow disabling all operations
            guard ops.count > 1 else { return }
            ops.remove(operation)
        } else {
            ops.insert(operation)
        }
        enabledOperations = ops
    }

    func isOperationEnabled(_ operation: MathOperation) -> Bool {
        enabledOperations.contains(operation)
    }

    func resetProgress() async {
        do {
            try storageService.resetAllSkills()
            let profile = try storageService.getOrCreateProfile()
            profile.streakCount = 0
            profile.totalSessions = 0
            profile.totalProblemsSolved = 0
            profile.bestPracticeAccuracy = nil
            profile.bestTimeAttackCount = nil
            profile.diagnosticCompleted = false
        } catch {
            // Silently handle
        }
    }

    func retakeDiagnostic() async {
        do {
            try storageService.resetAllSkills()
            let profile = try storageService.getOrCreateProfile()
            profile.diagnosticCompleted = false
        } catch {
            // Silently handle
        }
        AppSettings.shared.hasCompletedOnboarding = false
    }
}
