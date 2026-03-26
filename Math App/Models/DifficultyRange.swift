import Foundation

enum DifficultyRange: String, Codable, CaseIterable, Identifiable, Comparable {
    case singleDigit = "1digit"
    case twoDigit = "2digit"
    case threeDigit = "3digit"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .singleDigit: "Easy"
        case .twoDigit: "Medium"
        case .threeDigit: "Hard"
        }
    }

    var subtitle: String {
        switch self {
        case .singleDigit: "1-digit numbers"
        case .twoDigit: "2-digit numbers"
        case .threeDigit: "3-digit numbers"
        }
    }

    var operandRange: ClosedRange<Int> {
        switch self {
        case .singleDigit: 2...9
        case .twoDigit: 10...99
        case .threeDigit: 100...999
        }
    }

    /// For multiplication, use smaller ranges to keep problems reasonable
    var multiplicationRange: ClosedRange<Int> {
        switch self {
        case .singleDigit: 2...9
        case .twoDigit: 2...19
        case .threeDigit: 2...99
        }
    }

    /// For division, the divisor range
    var divisionDivisorRange: ClosedRange<Int> {
        switch self {
        case .singleDigit: 2...9
        case .twoDigit: 2...19
        case .threeDigit: 2...99
        }
    }

    /// For division, the answer range
    var divisionAnswerRange: ClosedRange<Int> {
        switch self {
        case .singleDigit: 2...9
        case .twoDigit: 2...99
        case .threeDigit: 2...999
        }
    }

    private var sortOrder: Int {
        switch self {
        case .singleDigit: 0
        case .twoDigit: 1
        case .threeDigit: 2
        }
    }

    static func < (lhs: DifficultyRange, rhs: DifficultyRange) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}
