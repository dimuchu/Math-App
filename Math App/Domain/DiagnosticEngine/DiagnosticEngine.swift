import Foundation

struct DiagnosticEngine: Sendable {
    static let problemCount = 12

    /// Generate diagnostic problem sequence: simple → complex, covering all operations
    func generateDiagnosticProblems(operations: Set<MathOperation> = Set(MathOperation.allCases)) -> [Problem] {
        let generator = RandomProblemGenerator()
        var problems: [Problem] = []
        let ops = Array(operations.isEmpty ? Set(MathOperation.allCases) : operations)

        // 4 easy (single digit), 4 medium (two digit), 4 hard (three digit)
        let difficulties: [DifficultyRange] = [.singleDigit, .twoDigit, .threeDigit]

        for difficulty in difficulties {
            for i in 0..<4 {
                let op = ops[i % ops.count]
                problems.append(generator.generate(operations: [op], difficulty: difficulty))
            }
        }

        return problems
    }

    /// Analyze diagnostic results and return initial skill ratings
    func analyzeResults(attempts: [Attempt]) -> [SkillRating] {
        var grouped: [String: [Attempt]] = [:]

        for attempt in attempts {
            let key = SkillLevel.makeKey(
                operation: attempt.problem.operation,
                digitRange: attempt.problem.difficulty
            )
            grouped[key, default: []].append(attempt)
        }

        return grouped.map { key, attempts in
            let correct = attempts.filter(\.isCorrect)
            let accuracy = Double(correct.count) / Double(attempts.count)
            let avgTime = attempts.map(\.responseTime).reduce(0, +) / Double(attempts.count)

            // Rating: accuracy weighted 70%, speed weighted 30%
            // Speed factor: <3s = 1.0, >10s = 0.0, linear between
            let speedFactor = max(0, min(1, (10.0 - avgTime) / 7.0))
            let rating = accuracy * 0.7 + speedFactor * 0.3

            let parts = key.split(separator: "_")
            let operation = MathOperation(rawValue: String(parts[0])) ?? .addition
            let range = DifficultyRange(rawValue: String(parts[1])) ?? .singleDigit

            return SkillRating(
                operation: operation,
                digitRange: range,
                rating: min(max(rating, 0.05), 0.95)
            )
        }
    }
}

struct SkillRating: Sendable {
    let operation: MathOperation
    let digitRange: DifficultyRange
    let rating: Double
}
