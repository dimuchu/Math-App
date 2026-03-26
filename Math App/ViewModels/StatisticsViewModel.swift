import SwiftUI
import SwiftData

@Observable
@MainActor
final class StatisticsViewModel {
    private let storageService: SwiftDataStorageService

    private(set) var totalSolved: Int = 0
    private(set) var overallAccuracy: Double = 0
    private(set) var streakCount: Int = 0
    private(set) var recentSessions: [Session] = []
    private(set) var skillLevels: [SkillLevel] = []

    var operationSkills: [(operation: MathOperation, rating: Double)] {
        let grouped = Dictionary(grouping: skillLevels, by: \.operation)
        return MathOperation.allCases.compactMap { op in
            guard let levels = grouped[op], !levels.isEmpty else { return nil }
            let avg = levels.map { $0.clampedRating() }.reduce(0, +) / Double(levels.count)
            return (operation: op, rating: avg)
        }
    }

    init(modelContext: ModelContext) {
        self.storageService = SwiftDataStorageService(modelContext: modelContext)
    }

    func load() async {
        do {
            let profile = try storageService.getOrCreateProfile()
            totalSolved = profile.totalProblemsSolved
            streakCount = profile.streakCount

            recentSessions = try storageService.fetchRecentSessions(limit: 20)

            let totalCorrect = recentSessions.reduce(0) { $0 + $1.correctCount }
            let totalProblems = recentSessions.reduce(0) { $0 + $1.totalProblems }
            overallAccuracy = totalProblems > 0 ? Double(totalCorrect) / Double(totalProblems) : 0

            skillLevels = try storageService.fetchAllSkills()
        } catch {
            // Continue with empty data
        }
    }
}
