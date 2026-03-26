import Foundation

protocol ProblemGenerating: Sendable {
    func generate(
        operations: Set<MathOperation>,
        difficulty: DifficultyRange
    ) -> Problem

    func generateBatch(
        count: Int,
        operations: Set<MathOperation>,
        difficulty: DifficultyRange
    ) -> [Problem]
}

extension ProblemGenerating {
    func generateBatch(
        count: Int,
        operations: Set<MathOperation>,
        difficulty: DifficultyRange
    ) -> [Problem] {
        (0..<count).map { _ in generate(operations: operations, difficulty: difficulty) }
    }
}
