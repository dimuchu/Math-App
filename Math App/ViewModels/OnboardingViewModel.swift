import SwiftUI
import SwiftData

enum OnboardingStep: Equatable {
    case welcome
    case diagnostic
    case diagnosticResults
}

@Observable
@MainActor
final class OnboardingViewModel {
    private let storageService: SwiftDataStorageService
    private let diagnosticEngine = DiagnosticEngine()
    private let settings = AppSettings.shared

    private(set) var step: OnboardingStep = .welcome
    private(set) var currentPage: Int = 0

    // Diagnostic state
    private(set) var diagnosticProblems: [Problem] = []
    private(set) var currentProblemIndex: Int = 0
    private(set) var diagnosticAttempts: [Attempt] = []
    private(set) var diagnosticResults: [SkillRating] = []
    private(set) var currentProblem: Problem?
    private(set) var diagnosticState: TrainingState = .solving

    var userInput: String = ""
    var isNegative: Bool = false
    private var problemStartTime: Date = .now

    var displayInput: String {
        if userInput.isEmpty { return "" }
        return isNegative ? "−\(userInput)" : userInput
    }

    var isSubmitEnabled: Bool {
        !userInput.isEmpty && diagnosticState == .solving
    }

    var diagnosticProgress: Double {
        guard !diagnosticProblems.isEmpty else { return 0 }
        return Double(currentProblemIndex) / Double(diagnosticProblems.count)
    }

    var weakestSkill: SkillRating? {
        diagnosticResults.min(by: { $0.rating < $1.rating })
    }

    var strongestSkill: SkillRating? {
        diagnosticResults.max(by: { $0.rating < $1.rating })
    }

    /// Aggregated results by operation
    var operationResults: [(operation: MathOperation, rating: Double)] {
        let grouped = Dictionary(grouping: diagnosticResults, by: \.operation)
        return MathOperation.allCases.compactMap { op in
            guard let ratings = grouped[op] else { return nil }
            let avg = ratings.map(\.rating).reduce(0, +) / Double(ratings.count)
            return (operation: op, rating: avg)
        }
    }

    init(modelContext: ModelContext) {
        self.storageService = SwiftDataStorageService(modelContext: modelContext)
    }

    func startDiagnostic() {
        step = .diagnostic
        diagnosticProblems = diagnosticEngine.generateDiagnosticProblems()
        currentProblemIndex = 0
        diagnosticAttempts = []
        advanceToNext()
    }

    func skip() {
        Task { @MainActor in await skipDiagnostic() }
    }

    func complete() {
        settings.hasCompletedOnboarding = true
    }

    // MARK: - Diagnostic Input

    func appendDigit(_ digit: Int) {
        guard diagnosticState == .solving else { return }
        guard userInput.count < 7 else { return }
        if userInput == "0" { userInput = "" }
        userInput += "\(digit)"
    }

    func deleteLastDigit() {
        guard diagnosticState == .solving else { return }
        if !userInput.isEmpty { userInput.removeLast() }
    }

    func toggleMinus() {
        guard diagnosticState == .solving else { return }
        isNegative.toggle()
    }

    func submitAnswer() {
        guard diagnosticState == .solving, !userInput.isEmpty, let problem = currentProblem else { return }

        let answerValue = Int(userInput) ?? 0
        let finalAnswer = isNegative ? -answerValue : answerValue
        let responseTime = Date.now.timeIntervalSince(problemStartTime)

        let attempt = Attempt(problem: problem, userAnswer: finalAnswer, responseTime: responseTime)
        diagnosticAttempts.append(attempt)

        let isCorrect = attempt.isCorrect
        diagnosticState = .feedback(isCorrect: isCorrect)

        if isCorrect {
            HapticService.shared.correctAnswer()
        } else {
            HapticService.shared.wrongAnswer()
        }

        let delay = isCorrect ? MMAnimation.correctFeedbackDuration : MMAnimation.errorFeedbackDuration
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(delay))
            afterFeedback()
        }
    }

    // MARK: - Private

    private func afterFeedback() {
        currentProblemIndex += 1

        if currentProblemIndex >= diagnosticProblems.count {
            finishDiagnostic()
        } else {
            advanceToNext()
        }
    }

    private func advanceToNext() {
        userInput = ""
        isNegative = false
        currentProblem = diagnosticProblems[currentProblemIndex]
        problemStartTime = .now
        diagnosticState = .solving
    }

    private func finishDiagnostic() {
        diagnosticResults = diagnosticEngine.analyzeResults(attempts: diagnosticAttempts)
        step = .diagnosticResults

        Task { @MainActor in await saveDiagnosticResults() }
    }

    private func saveDiagnosticResults() async {
        do {
            for rating in diagnosticResults {
                let skill = SkillLevel(operation: rating.operation, digitRange: rating.digitRange, rating: rating.rating)
                skill.lastPracticed = .now
                try storageService.saveSkill(skill)
            }
            let profile = try storageService.getOrCreateProfile()
            profile.diagnosticCompleted = true
        } catch {
            // Continue without saving
        }
    }

    private func skipDiagnostic() async {
        // Set default medium rating for all skills
        do {
            for operation in MathOperation.allCases {
                for range in DifficultyRange.allCases {
                    let skill = SkillLevel(operation: operation, digitRange: range, rating: 0.5)
                    try storageService.saveSkill(skill)
                }
            }
            let profile = try storageService.getOrCreateProfile()
            profile.diagnosticCompleted = true
        } catch {
            // Continue
        }
        settings.hasCompletedOnboarding = true
    }
}
