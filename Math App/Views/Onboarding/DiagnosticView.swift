import SwiftUI

struct DiagnosticView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            ProgressView(value: viewModel.diagnosticProgress)
                .tint(MMColors.Semantic.accent)
                .padding(.horizontal, MMSpacing.lg)
                .padding(.top, MMSpacing.lg)

            Text("\(viewModel.currentProblemIndex + 1) of \(DiagnosticEngine.problemCount)")
                .font(MMFonts.caption)
                .foregroundStyle(MMColors.Text.secondary)
                .padding(.top, MMSpacing.sm)

            Spacer()

            // Problem + feedback
            ZStack {
                if let problem = viewModel.currentProblem {
                    MMProblemView(problem: problem, userInput: viewModel.displayInput)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .id(viewModel.currentProblemIndex)
                }

                if case .feedback(let isCorrect) = viewModel.diagnosticState {
                    MMFeedbackView(
                        isCorrect: isCorrect,
                        correctAnswer: isCorrect ? nil : viewModel.currentProblem?.correctAnswer
                    )
                    .transition(.opacity)
                }
            }
            .animation(MMAnimation.problemTransition, value: viewModel.currentProblemIndex)

            Spacer()

            // Numpad
            MMNumpad(
                onDigit: viewModel.appendDigit,
                onDelete: viewModel.deleteLastDigit,
                onToggleMinus: viewModel.toggleMinus,
                onSubmit: viewModel.submitAnswer,
                isSubmitEnabled: viewModel.isSubmitEnabled
            )
            .padding(.bottom, MMSpacing.xxl)
        }
    }
}
