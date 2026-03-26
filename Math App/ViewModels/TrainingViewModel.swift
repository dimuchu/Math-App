import SwiftUI
import SwiftData

enum TrainingState: Equatable {
    case solving
    case feedback(isCorrect: Bool)
    case finished
}

@Observable
@MainActor
final class TrainingViewModel {
    let mode: TrainingMode
    private let storageService: SwiftDataStorageService
    private let adaptiveEngine = AdaptiveEngine()
    private let scoreCalculator = ScoreCalculator()

    private(set) var currentProblem: Problem?
    private(set) var state: TrainingState = .solving
    private(set) var attempts: [Attempt] = []
    private(set) var result: ScoreCalculator.SessionResult?

    var userInput: String = ""
    var isNegative: Bool = false

    // Progress tracking
    private(set) var currentIndex: Int = 0
    private(set) var remainingSeconds: Int = 0

    private var problemStartTime: Date = .now
    private var problems: [Problem] = []
    private var timer: Timer?
    private var skillLevels: [SkillLevel] = []
    private var previousBestAccuracy: Double?
    private var previousBestCount: Int?

    var totalProblems: Int {
        switch mode {
        case .practice(let count): count
        case .timeAttack: attempts.count
        }
    }

    var progressText: String {
        switch mode {
        case .practice(let count):
            "\(currentIndex + 1)/\(count)"
        case .timeAttack:
            "\(attempts.count)"
        }
    }

    var displayInput: String {
        if userInput.isEmpty { return "" }
        return isNegative ? "−\(userInput)" : userInput
    }

    var isSubmitEnabled: Bool {
        !userInput.isEmpty && state == .solving
    }

    var isTimeAttack: Bool {
        if case .timeAttack = mode { return true }
        return false
    }

    init(mode: TrainingMode, modelContext: ModelContext) {
        self.mode = mode
        self.storageService = SwiftDataStorageService(modelContainer: modelContext.container)
    }

    func start() async {
        await loadSkillsAndRecords()
        generateProblems()

        if case .timeAttack(let seconds) = mode {
            remainingSeconds = seconds
            startTimer()
        }

        advanceToNextProblem()
    }

    // MARK: - Input

    func appendDigit(_ digit: Int) {
        guard state == .solving else { return }
        guard userInput.count < 7 else { return }
        // No leading zeros
        if userInput == "0" { userInput = "" }
        userInput += "\(digit)"
    }

    func deleteLastDigit() {
        guard state == .solving else { return }
        if !userInput.isEmpty {
            userInput.removeLast()
        }
    }

    func toggleMinus() {
        guard state == .solving else { return }
        isNegative.toggle()
    }

    func submit() {
        guard state == .solving, !userInput.isEmpty, let problem = currentProblem else { return }

        let answerValue = Int(userInput) ?? 0
        let finalAnswer = isNegative ? -answerValue : answerValue
        let responseTime = Date.now.timeIntervalSince(problemStartTime)

        let attempt = Attempt(problem: problem, userAnswer: finalAnswer, responseTime: responseTime)
        attempts.append(attempt)

        let isCorrect = attempt.isCorrect
        state = .feedback(isCorrect: isCorrect)

        if isCorrect {
            HapticService.shared.correctAnswer()
        } else {
            HapticService.shared.wrongAnswer()
        }

        let delay = isCorrect ? MMAnimation.correctFeedbackDuration : MMAnimation.errorFeedbackDuration
        Task {
            try? await Task.sleep(for: .seconds(delay))
            afterFeedback()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Private

    private func afterFeedback() {
        guard state != .finished else { return }

        switch mode {
        case .practice(let count):
            if attempts.count >= count {
                finishSession()
            } else {
                advanceToNextProblem()
            }
        case .timeAttack:
            if remainingSeconds <= 0 {
                finishSession()
            } else {
                advanceToNextProblem()
            }
        }
    }

    private func advanceToNextProblem() {
        userInput = ""
        isNegative = false
        currentIndex = attempts.count

        if currentIndex < problems.count {
            currentProblem = problems[currentIndex]
        } else {
            // Generate more problems on the fly (for time attack)
            let generator = makeGenerator()
            let settings = AppSettings.shared
            let newProblem = generator.generate(operations: settings.enabledOperations, difficulty: settings.difficulty)
            problems.append(newProblem)
            currentProblem = newProblem
        }

        problemStartTime = .now
        state = .solving
    }

    private func finishSession() {
        stop()
        state = .finished

        result = scoreCalculator.calculateResult(
            attempts: attempts,
            mode: mode,
            previousBestAccuracy: previousBestAccuracy,
            previousBestCount: previousBestCount
        )

        Task {
            await saveSession()
        }
    }

    private func generateProblems() {
        let generator = makeGenerator()
        let settings = AppSettings.shared

        let count: Int
        switch mode {
        case .practice(let c): count = c
        case .timeAttack: count = 50 // Pre-generate a batch
        }

        problems = generator.generateBatch(count: count, operations: settings.enabledOperations, difficulty: settings.difficulty)
    }

    private func makeGenerator() -> any ProblemGenerating {
        if skillLevels.isEmpty {
            return RandomProblemGenerator()
        }
        return AdaptiveProblemGenerator(skillLevels: skillLevels)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.timerTick()
            }
        }
    }

    private func timerTick() {
        guard remainingSeconds > 0 else {
            finishSession()
            return
        }
        remainingSeconds -= 1
        if remainingSeconds <= 10 && remainingSeconds > 0 {
            HapticService.shared.timerWarning()
        }
        if remainingSeconds <= 0 {
            finishSession()
        }
    }

    private func loadSkillsAndRecords() async {
        do {
            skillLevels = try await storageService.fetchAllSkills()
            let profile = try await storageService.getOrCreateProfile()
            previousBestAccuracy = profile.bestPracticeAccuracy
            previousBestCount = profile.bestTimeAttackCount
        } catch {
            // Continue with defaults
        }
    }

    private func saveSession() async {
        guard !attempts.isEmpty else { return }

        do {
            let session = Session(mode: mode, attempts: attempts)
            try await storageService.saveSession(session)

            // Update skill ratings
            let updates = adaptiveEngine.processAttempts(attempts, currentSkills: skillLevels)
            for update in updates {
                if let existing = try await storageService.fetchSkill(for: update.operation, digitRange: update.digitRange) {
                    existing.rating = update.newRating
                    existing.lastPracticed = .now
                } else {
                    let skill = SkillLevel(operation: update.operation, digitRange: update.digitRange, rating: update.newRating)
                    skill.lastPracticed = .now
                    try await storageService.saveSkill(skill)
                }
            }

            // Update profile
            let profile = try await storageService.getOrCreateProfile()
            profile.totalSessions += 1
            profile.totalProblemsSolved += attempts.count

            // Streak: only if >= 3 problems
            if attempts.count >= 3 {
                profile.updateStreak()
            }

            // Records
            if let result {
                if case .practice = mode, result.accuracy > (profile.bestPracticeAccuracy ?? 0) {
                    profile.bestPracticeAccuracy = result.accuracy
                }
                if case .timeAttack = mode, result.totalProblems > (profile.bestTimeAttackCount ?? 0) {
                    profile.bestTimeAttackCount = result.totalProblems
                }
            }
        } catch {
            // Silently handle storage errors
        }
    }
}
