import Foundation

struct Problem: Codable, Equatable, Sendable {
    let operandA: Int
    let operandB: Int
    let operation: MathOperation
    let correctAnswer: Int
    let difficulty: DifficultyRange

    var voiceOverText: String {
        "\(operandA) \(operation.voiceOverDescription) \(operandB)"
    }

    func isAnswerCorrect(_ answer: Int) -> Bool {
        answer == correctAnswer
    }
}
