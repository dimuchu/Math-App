import Foundation
import SwiftData

@Model
final class UserProfile {
    var streakCount: Int
    var lastActiveDate: Date?
    var diagnosticCompleted: Bool
    var totalSessions: Int
    var totalProblemsSolved: Int
    var bestPracticeAccuracy: Double?
    var bestTimeAttackCount: Int?

    init(
        streakCount: Int = 0,
        lastActiveDate: Date? = nil,
        diagnosticCompleted: Bool = false,
        totalSessions: Int = 0,
        totalProblemsSolved: Int = 0
    ) {
        self.streakCount = streakCount
        self.lastActiveDate = lastActiveDate
        self.diagnosticCompleted = diagnosticCompleted
        self.totalSessions = totalSessions
        self.totalProblemsSolved = totalProblemsSolved
    }

    /// Update streak based on current date. Returns true if streak was incremented.
    @discardableResult
    func updateStreak(currentDate: Date = .now) -> Bool {
        let calendar = Calendar.current

        guard let lastActive = lastActiveDate else {
            streakCount = 1
            lastActiveDate = currentDate
            return true
        }

        if calendar.isDate(lastActive, inSameDayAs: currentDate) {
            return false
        }

        if let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: currentDate)),
           calendar.isDate(lastActive, inSameDayAs: yesterday) {
            streakCount += 1
        } else {
            streakCount = 1
        }

        lastActiveDate = currentDate
        return true
    }

    /// Check if streak should be reset (called on app launch)
    func checkStreakValidity(currentDate: Date = .now) {
        let calendar = Calendar.current

        guard let lastActive = lastActiveDate else {
            streakCount = 0
            return
        }

        let daysSince = calendar.dateComponents([.day], from: calendar.startOfDay(for: lastActive), to: calendar.startOfDay(for: currentDate)).day ?? 0

        if daysSince > 1 {
            streakCount = 0
        }
    }
}
