import SwiftUI

struct MMProblemView: View {
    let problem: Problem
    let userInput: String

    var body: some View {
        VStack(spacing: MMSpacing.xl) {
            // Problem display
            HStack(spacing: MMSpacing.md) {
                Text("\(problem.operandA)")
                    .font(MMFonts.display)
                    .foregroundStyle(MMColors.Text.primary)

                Text(problem.operation.symbol)
                    .font(MMFonts.operator)
                    .foregroundStyle(MMColors.Text.secondary)

                Text("\(problem.operandB)")
                    .font(MMFonts.display)
                    .foregroundStyle(MMColors.Text.primary)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(problem.voiceOverText)

            // User input display
            Text(userInput.isEmpty ? " " : userInput)
                .font(MMFonts.statLarge)
                .foregroundStyle(MMColors.Text.primary)
                .contentTransition(.numericText())
                .accessibilityLabel(userInput.isEmpty ? "No answer entered" : "Your answer: \(userInput)")
        }
    }
}

#Preview {
    MMProblemView(
        problem: Problem(operandA: 24, operandB: 7, operation: .multiplication, correctAnswer: 168, difficulty: .twoDigit),
        userInput: "168"
    )
}
