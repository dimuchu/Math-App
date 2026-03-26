import Foundation

enum TrainingMode: Codable, Equatable, Sendable {
    case practice(count: Int)
    case timeAttack(seconds: Int)

    var displayName: String {
        switch self {
        case .practice: "Practice"
        case .timeAttack: "Time Attack"
        }
    }

    var subtitle: String {
        switch self {
        case .practice: "Train at your pace"
        case .timeAttack: "Race against time"
        }
    }

    var iconName: String {
        switch self {
        case .practice: "brain.head.profile"
        case .timeAttack: "timer"
        }
    }
}
