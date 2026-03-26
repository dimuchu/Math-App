import SwiftUI

struct MMFeedbackView: View {
    let isCorrect: Bool
    let correctAnswer: Int?

    var body: some View {
        ZStack {
            if isCorrect {
                MMColors.Semantic.success.opacity(0.15)
            } else {
                VStack(spacing: MMSpacing.sm) {
                    MMColors.Semantic.error.opacity(0.15)
                    if let correctAnswer {
                        Text("Correct: \(correctAnswer)")
                            .font(MMFonts.title2)
                            .foregroundStyle(MMColors.Semantic.error)
                    }
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isCorrect ? "Correct!" : "Wrong. The correct answer is \(correctAnswer ?? 0)")
    }
}
