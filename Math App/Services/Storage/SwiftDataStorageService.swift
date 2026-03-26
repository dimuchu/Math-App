import Foundation
import SwiftData

@MainActor
final class SwiftDataStorageService: StorageService {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - UserProfile

    func fetchProfile() throws -> UserProfile? {
        let descriptor = FetchDescriptor<UserProfile>()
        return try modelContext.fetch(descriptor).first
    }

    func saveProfile(_ profile: UserProfile) throws {
        modelContext.insert(profile)
        try modelContext.save()
    }

    func getOrCreateProfile() throws -> UserProfile {
        if let existing = try fetchProfile() {
            return existing
        }
        let profile = UserProfile()
        modelContext.insert(profile)
        try modelContext.save()
        return profile
    }

    // MARK: - SkillLevel

    func fetchAllSkills() throws -> [SkillLevel] {
        let descriptor = FetchDescriptor<SkillLevel>(
            sortBy: [SortDescriptor(\.skillKey)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchSkill(for operation: MathOperation, digitRange: DifficultyRange) throws -> SkillLevel? {
        let key = SkillLevel.makeKey(operation: operation, digitRange: digitRange)
        var descriptor = FetchDescriptor<SkillLevel>(
            predicate: #Predicate { $0.skillKey == key }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    func saveSkill(_ skill: SkillLevel) throws {
        modelContext.insert(skill)
        try modelContext.save()
    }

    func saveSkills(_ skills: [SkillLevel]) throws {
        for skill in skills {
            modelContext.insert(skill)
        }
        try modelContext.save()
    }

    func resetAllSkills() throws {
        let skills = try fetchAllSkills()
        for skill in skills {
            modelContext.delete(skill)
        }
        try modelContext.save()
    }

    // MARK: - Session

    func saveSession(_ session: Session) throws {
        modelContext.insert(session)
        try modelContext.save()
    }

    func fetchRecentSessions(limit: Int) throws -> [Session] {
        var descriptor = FetchDescriptor<Session>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try modelContext.fetch(descriptor)
    }

    func fetchAllSessions() throws -> [Session] {
        let descriptor = FetchDescriptor<Session>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
}
