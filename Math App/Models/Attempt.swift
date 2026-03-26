import Foundation

struct Attempt: Codable, Equatable, Sendable {
    let problem: Problem
    let userAnswer: Int
    let isCorrect: Bool
    let responseTime: TimeInterval

    init(problem: Problem, userAnswer: Int, responseTime: TimeInterval) {
        self.problem = problem
        self.userAnswer = userAnswer
        self.isCorrect = problem.isAnswerCorrect(userAnswer)
        self.responseTime = responseTime
    }
}
