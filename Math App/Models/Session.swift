import Foundation
import SwiftData

@MainActor
@Model
final class Session {
    var startDate: Date
    var endDate: Date?
    var mode: TrainingMode
    var attemptsData: Data

    var totalProblems: Int
    var correctCount: Int
    var averageTime: TimeInterval
    var bestStreak: Int

    init(
        startDate: Date = .now,
        mode: TrainingMode,
        attempts: [Attempt] = []
    ) {
        self.startDate = startDate
        self.mode = mode
        self.attemptsData = (try? JSONEncoder().encode(attempts)) ?? Data()
        self.totalProblems = attempts.count
        self.correctCount = attempts.filter(\.isCorrect).count
        self.averageTime = attempts.isEmpty ? 0 : attempts.map(\.responseTime).reduce(0, +) / Double(attempts.count)
        self.bestStreak = Self.calculateBestStreak(attempts)
    }

    var attempts: [Attempt] {
        get {
            (try? JSONDecoder().decode([Attempt].self, from: attemptsData)) ?? []
        }
        set {
            attemptsData = (try? JSONEncoder().encode(newValue)) ?? Data()
            totalProblems = newValue.count
            correctCount = newValue.filter(\.isCorrect).count
            averageTime = newValue.isEmpty ? 0 : newValue.map(\.responseTime).reduce(0, +) / Double(newValue.count)
            bestStreak = Self.calculateBestStreak(newValue)
        }
    }

    var accuracy: Double {
        guard totalProblems > 0 else { return 0 }
        return Double(correctCount) / Double(totalProblems)
    }

    var errorCount: Int {
        totalProblems - correctCount
    }

    private static func calculateBestStreak(_ attempts: [Attempt]) -> Int {
        var best = 0
        var current = 0
        for attempt in attempts {
            if attempt.isCorrect {
                current += 1
                best = max(best, current)
            } else {
                current = 0
            }
        }
        return best
    }
}
