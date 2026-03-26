import Foundation

struct AdaptiveProblemGenerator: ProblemGenerating {
    let skillLevels: [SkillLevel]
    private let weakZoneRatio = 0.7

    func generate(
        operations: Set<MathOperation>,
        difficulty: DifficultyRange
    ) -> Problem {
        let ops = operations.isEmpty ? Set(MathOperation.allCases) : operations
        let operation = selectWeightedOperation(from: ops, difficulty: difficulty)
        let effectiveDifficulty = adjustDifficulty(for: operation, base: difficulty)
        return generateProblem(operation: operation, difficulty: effectiveDifficulty)
    }

    /// Select operation weighted toward weak skills (~70% weak, ~30% strong)
    private func selectWeightedOperation(
        from operations: Set<MathOperation>,
        difficulty: DifficultyRange
    ) -> MathOperation {
        let ops = Array(operations)
        guard ops.count > 1 else { return ops[0] }

        let weights: [(MathOperation, Double)] = ops.map { op in
            let key = SkillLevel.makeKey(operation: op, digitRange: difficulty)
            let rating = skillLevels.first(where: { $0.skillKey == key })?.clampedRating() ?? 0.5
            // Lower rating = higher weight (more likely to be selected)
            let weight = 1.0 - rating
            return (op, max(weight, 0.05))
        }

        let totalWeight = weights.map(\.1).reduce(0, +)
        var random = Double.random(in: 0..<totalWeight)

        for (op, weight) in weights {
            random -= weight
            if random <= 0 { return op }
        }

        return ops.last!
    }

    /// Auto-increase difficulty when plateau detected (rating > 0.85)
    private func adjustDifficulty(for operation: MathOperation, base: DifficultyRange) -> DifficultyRange {
        let key = SkillLevel.makeKey(operation: operation, digitRange: base)
        guard let skill = skillLevels.first(where: { $0.skillKey == key }) else { return base }

        if skill.clampedRating() > 0.85 {
            switch base {
            case .singleDigit: return .twoDigit
            case .twoDigit: return .threeDigit
            case .threeDigit: return .threeDigit
            }
        }

        return base
    }

    private func generateProblem(operation: MathOperation, difficulty: DifficultyRange) -> Problem {
        let random = RandomProblemGenerator()
        return random.generate(operations: [operation], difficulty: difficulty)
    }
}
