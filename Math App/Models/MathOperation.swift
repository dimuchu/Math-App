import Foundation

enum MathOperation: String, Codable, CaseIterable, Identifiable {
    case addition = "addition"
    case subtraction = "subtraction"
    case multiplication = "multiplication"
    case division = "division"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .addition: "+"
        case .subtraction: "−"
        case .multiplication: "×"
        case .division: "÷"
        }
    }

    var displayName: String {
        switch self {
        case .addition: "Addition"
        case .subtraction: "Subtraction"
        case .multiplication: "Multiplication"
        case .division: "Division"
        }
    }

    var voiceOverDescription: String {
        switch self {
        case .addition: "plus"
        case .subtraction: "minus"
        case .multiplication: "times"
        case .division: "divided by"
        }
    }
}
