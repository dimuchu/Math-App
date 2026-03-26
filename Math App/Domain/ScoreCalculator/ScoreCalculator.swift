import Foundation

struct ScoreCalculator: Sendable {
    struct SessionResult: Sendable {
        let totalProblems: Int
        let correctCount: Int
        let errorCount: Int
        let accuracy: Double
        let averageTime: TimeInterval
        let bestStreak: Int
        let isNewAccuracyRecord: Bool
        let isNewCountRecord: Bool
    }

    func calculateResult(
        attempts: [Attempt],
        mode: TrainingMode,
        previousBestAccuracy: Double?,
        previousBestCount: Int?
    ) -> SessionResult {
        let correct = attempts.filter(\.isCorrect).count
        let total = attempts.count
        let accuracy = total > 0 ? Double(correct) / Double(total) : 0
        let avgTime = total > 0 ? attempts.map(\.responseTime).reduce(0, +) / Double(total) : 0
        let bestStreak = calculateBestStreak(attempts)

        let isNewAccuracyRecord: Bool
        let isNewCountRecord: Bool

        switch mode {
        case .practice:
            isNewAccuracyRecord = accuracy > (previousBestAccuracy ?? 0)
            isNewCountRecord = false
        case .timeAttack:
            isNewAccuracyRecord = false
            isNewCountRecord = total > (previousBestCount ?? 0)
        }

        return SessionResult(
            totalProblems: total,
            correctCount: correct,
            errorCount: total - correct,
            accuracy: accuracy,
            averageTime: avgTime,
            bestStreak: bestStreak,
            isNewAccuracyRecord: isNewAccuracyRecord,
            isNewCountRecord: isNewCountRecord
        )
    }

    private func calculateBestStreak(_ attempts: [Attempt]) -> Int {
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
