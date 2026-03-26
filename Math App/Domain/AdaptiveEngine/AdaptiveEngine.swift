import Foundation

struct AdaptiveEngine: Sendable {
    /// Update a skill rating based on an attempt. Errors weight 2x.
    func updatedRating(
        currentRating: Double,
        isCorrect: Bool,
        responseTime: TimeInterval
    ) -> Double {
        let baseChange: Double = 0.05

        if isCorrect {
            // Speed bonus: faster = bigger increase, slower = smaller
            let speedMultiplier = max(0.5, min(1.5, 5.0 / max(responseTime, 1.0)))
            let increase = baseChange * speedMultiplier
            return min(currentRating + increase, 0.99)
        } else {
            // Errors weight 2x
            let decrease = baseChange * 2.0
            return max(currentRating - decrease, 0.01)
        }
    }

    /// Process a batch of attempts and return updated ratings
    func processAttempts(
        _ attempts: [Attempt],
        currentSkills: [SkillLevel]
    ) -> [SkillUpdate] {
        var updates: [String: SkillUpdate] = [:]

        for attempt in attempts {
            let key = SkillLevel.makeKey(
                operation: attempt.problem.operation,
                digitRange: attempt.problem.difficulty
            )

            let currentRating: Double
            if let existing = updates[key] {
                currentRating = existing.newRating
            } else if let skill = currentSkills.first(where: { $0.skillKey == key }) {
                currentRating = skill.clampedRating()
            } else {
                currentRating = 0.5
            }

            let newRating = updatedRating(
                currentRating: currentRating,
                isCorrect: attempt.isCorrect,
                responseTime: attempt.responseTime
            )

            updates[key] = SkillUpdate(
                operation: attempt.problem.operation,
                digitRange: attempt.problem.difficulty,
                newRating: newRating
            )
        }

        return Array(updates.values)
    }
}

struct SkillUpdate: Sendable {
    let operation: MathOperation
    let digitRange: DifficultyRange
    let newRating: Double
}
