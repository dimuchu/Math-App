import Foundation
import SwiftData

@Model
final class SkillLevel {
    #Unique<SkillLevel>([\.skillKey])

    var skillKey: String
    var operation: MathOperation
    var digitRange: DifficultyRange
    var rating: Double
    var lastPracticed: Date?

    init(operation: MathOperation, digitRange: DifficultyRange, rating: Double = 0.5) {
        self.skillKey = Self.makeKey(operation: operation, digitRange: digitRange)
        self.operation = operation
        self.digitRange = digitRange
        self.rating = rating
    }

    static func makeKey(operation: MathOperation, digitRange: DifficultyRange) -> String {
        "\(operation.rawValue)_\(digitRange.rawValue)"
    }

    /// Clamp rating to valid range
    func clampedRating() -> Double {
        min(max(rating, 0.0), 1.0)
    }

    /// Apply decay for inactivity. Rate: ~2% per day, not applied same day.
    func applyDecay(currentDate: Date = .now) {
        guard let lastPracticed else { return }

        let calendar = Calendar.current
        if calendar.isDate(lastPracticed, inSameDayAs: currentDate) { return }

        let daysSince = calendar.dateComponents([.day], from: calendar.startOfDay(for: lastPracticed), to: calendar.startOfDay(for: currentDate)).day ?? 0
        guard daysSince > 0 else { return }

        let decayRate = 0.02
        let decayFactor = pow(1.0 - decayRate, Double(daysSince))
        rating = max(rating * decayFactor, 0.05)
    }
}
