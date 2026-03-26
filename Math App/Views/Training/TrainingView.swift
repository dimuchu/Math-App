import SwiftUI
import SwiftData

struct TrainingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: TrainingViewModel

    init(mode: TrainingMode, modelContext: ModelContext) {
        _viewModel = State(initialValue: TrainingViewModel(mode: mode, modelContext: modelContext))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .solving, .feedback:
                trainingContent
            case .finished:
                if let result = viewModel.result {
                    ResultsView(
                        result: result,
                        mode: viewModel.mode,
                        onTryAgain: {
                            viewModel.stop()
                            viewModel = TrainingViewModel(mode: viewModel.mode, modelContext: modelContext)
                            Task { await viewModel.start() }
                        },
                        onHome: { dismiss() }
                    )
                }
            }
        }
        .task { await viewModel.start() }
        .onDisappear { viewModel.stop() }
    }

    private var trainingContent: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Button { viewModel.stop(); dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundStyle(MMColors.Text.secondary)
                }
                .accessibilityLabel("Close training")

                Spacer()

                if viewModel.isTimeAttack {
                    MMTimerView(remainingSeconds: viewModel.remainingSeconds)
                } else {
                    Text(viewModel.progressText)
                        .font(MMFonts.callout)
                        .foregroundStyle(MMColors.Text.secondary)
                }
            }
            .padding(.horizontal, MMSpacing.lg)
            .padding(.top, MMSpacing.lg)

            Spacer()

            // Problem + feedback overlay
            ZStack {
                if let problem = viewModel.currentProblem {
                    MMProblemView(problem: problem, userInput: viewModel.displayInput)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .id(viewModel.currentIndex)
                }

                if case .feedback(let isCorrect) = viewModel.state {
                    MMFeedbackView(
                        isCorrect: isCorrect,
                        correctAnswer: isCorrect ? nil : viewModel.currentProblem?.correctAnswer
                    )
                    .transition(.opacity)
                }
            }
            .animation(MMAnimation.problemTransition, value: viewModel.currentIndex)

            Spacer()

            // Numpad
            MMNumpad(
                onDigit: viewModel.appendDigit,
                onDelete: viewModel.deleteLastDigit,
                onToggleMinus: viewModel.toggleMinus,
                onSubmit: viewModel.submit,
                isSubmitEnabled: viewModel.isSubmitEnabled
            )
            .padding(.bottom, MMSpacing.xxl)
        }
    }
}
