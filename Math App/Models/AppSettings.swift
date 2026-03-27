import SwiftUI

@Observable
final class AppSettings {
    static let shared = AppSettings()

    @ObservationIgnored
    @AppStorage("enabledOperations") private var enabledOperationsRaw: String = "addition,subtraction,multiplication,division"

    @ObservationIgnored
    @AppStorage("difficulty") private var difficultyRaw: String = DifficultyRange.singleDigit.rawValue

    @ObservationIgnored
    @AppStorage("appearance") private var appearanceRaw: String = AppAppearance.system.rawValue

    @ObservationIgnored
    @AppStorage("hasUserSelectedAppearance") private var hasUserSelectedAppearance: Bool = false

    @ObservationIgnored
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    @ObservationIgnored
    @AppStorage("practiceCount") var practiceCount: Int = 10

    @ObservationIgnored
    @AppStorage("timeAttackSeconds") var timeAttackSeconds: Int = 60

    var enabledOperations: Set<MathOperation> {
        get {
            let ops = enabledOperationsRaw.split(separator: ",").compactMap { MathOperation(rawValue: String($0)) }
            return ops.isEmpty ? Set(MathOperation.allCases) : Set(ops)
        }
        set {
            enabledOperationsRaw = newValue.map(\.rawValue).sorted().joined(separator: ",")
        }
    }

    var difficulty: DifficultyRange {
        get { DifficultyRange(rawValue: difficultyRaw) ?? .singleDigit }
        set { difficultyRaw = newValue.rawValue }
    }

    var appearance: AppAppearance {
        get {
            guard hasUserSelectedAppearance else { return .system }
            return AppAppearance(rawValue: appearanceRaw) ?? .system
        }
        set {
            appearanceRaw = newValue.rawValue
            hasUserSelectedAppearance = true
        }
    }

    var colorScheme: ColorScheme? {
        appearance.colorScheme
    }

    private init() {}
}

enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}
