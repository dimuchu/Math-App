import Foundation

protocol StorageService: Sendable {
    // MARK: - UserProfile
    func fetchProfile() async throws -> UserProfile?
    func saveProfile(_ profile: UserProfile) async throws
    func getOrCreateProfile() async throws -> UserProfile

    // MARK: - SkillLevel
    func fetchAllSkills() async throws -> [SkillLevel]
    func fetchSkill(for operation: MathOperation, digitRange: DifficultyRange) async throws -> SkillLevel?
    func saveSkill(_ skill: SkillLevel) async throws
    func saveSkills(_ skills: [SkillLevel]) async throws
    func resetAllSkills() async throws

    // MARK: - Session
    func saveSession(_ session: Session) async throws
    func fetchRecentSessions(limit: Int) async throws -> [Session]
    func fetchAllSessions() async throws -> [Session]
}
