import Foundation

@MainActor
protocol StorageService {
    // MARK: - UserProfile
    func fetchProfile() throws -> UserProfile?
    func saveProfile(_ profile: UserProfile) throws
    func getOrCreateProfile() throws -> UserProfile

    // MARK: - SkillLevel
    func fetchAllSkills() throws -> [SkillLevel]
    func fetchSkill(for operation: MathOperation, digitRange: DifficultyRange) throws -> SkillLevel?
    func saveSkill(_ skill: SkillLevel) throws
    func saveSkills(_ skills: [SkillLevel]) throws
    func resetAllSkills() throws

    // MARK: - Session
    func saveSession(_ session: Session) throws
    func fetchRecentSessions(limit: Int) throws -> [Session]
    func fetchAllSessions() throws -> [Session]
}
