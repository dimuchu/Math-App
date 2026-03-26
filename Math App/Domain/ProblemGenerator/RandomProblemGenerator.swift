import Foundation

struct RandomProblemGenerator: ProblemGenerating {
    private var recentProblems: [String] = []
    private let maxRecent = 10

    func generate(
        operations: Set<MathOperation>,
        difficulty: DifficultyRange
    ) -> Problem {
        let ops = operations.isEmpty ? Set(MathOperation.allCases) : operations
        let operation = ops.randomElement()!
        return generateProblem(operation: operation, difficulty: difficulty)
    }

    private func generateProblem(operation: MathOperation, difficulty: DifficultyRange) -> Problem {
        switch operation {
        case .addition:
            return generateAddition(difficulty: difficulty)
        case .subtraction:
            return generateSubtraction(difficulty: difficulty)
        case .multiplication:
            return generateMultiplication(difficulty: difficulty)
        case .division:
            return generateDivision(difficulty: difficulty)
        }
    }

    private func generateAddition(difficulty: DifficultyRange) -> Problem {
        let range = difficulty.operandRange
        let a = Int.random(in: range)
        let b = Int.random(in: range)
        return Problem(operandA: a, operandB: b, operation: .addition, correctAnswer: a + b, difficulty: difficulty)
    }

    private func generateSubtraction(difficulty: DifficultyRange) -> Problem {
        let range = difficulty.operandRange
        let a = Int.random(in: range)
        let b = Int.random(in: range)
        return Problem(operandA: a, operandB: b, operation: .subtraction, correctAnswer: a - b, difficulty: difficulty)
    }

    private func generateMultiplication(difficulty: DifficultyRange) -> Problem {
        let range = difficulty.multiplicationRange
        let a = Int.random(in: range)
        let b = Int.random(in: range)
        return Problem(operandA: a, operandB: b, operation: .multiplication, correctAnswer: a * b, difficulty: difficulty)
    }

    /// Division: generate as answer × divisor = dividend to guarantee integer results
    private func generateDivision(difficulty: DifficultyRange) -> Problem {
        let divisorRange = difficulty.divisionDivisorRange
        let answerRange = difficulty.divisionAnswerRange
        let answer = Int.random(in: answerRange)
        let divisor = Int.random(in: divisorRange)
        let dividend = answer * divisor
        return Problem(operandA: dividend, operandB: divisor, operation: .division, correctAnswer: answer, difficulty: difficulty)
    }
}
