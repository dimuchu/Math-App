import SwiftUI

struct MMResultCard: View {
    let result: ScoreCalculator.SessionResult
    let mode: TrainingMode
    let onTryAgain: () -> Void
    let onHome: () -> Void

    @State private var showRecord = false

    private var heroValue: String {
        switch mode {
        case .practice:
            "\(Int(result.accuracy * 100))%"
        case .timeAttack:
            "\(result.totalProblems)"
        }
    }

    private var heroLabel: String {
        switch mode {
        case .practice: "Accuracy"
        case .timeAttack: "Problems Solved"
        }
    }

    private var isNewRecord: Bool {
        result.isNewAccuracyRecord || result.isNewCountRecord
    }

    var body: some View {
        VStack(spacing: MMSpacing.xxl) {
            // Hero stat
            VStack(spacing: MMSpacing.sm) {
                Text(heroValue)
                    .font(MMFonts.statLarge)
                    .foregroundStyle(MMColors.Text.primary)
                    .contentTransition(.numericText())

                Text(heroLabel)
                    .font(MMFonts.callout)
                    .foregroundStyle(MMColors.Text.secondary)
            }

            // Stats grid 2x2
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: MMSpacing.lg) {
                statCell(value: "\(result.correctCount)", label: "Solved")
                statCell(value: "\(result.errorCount)", label: "Errors")
                statCell(value: String(format: "%.1fs", result.averageTime), label: "Avg Time")
                statCell(value: "\(result.bestStreak)", label: "Best Streak")
            }
            .padding(MMSpacing.lg)
            .background(MMColors.Background.secondaryAdaptive, in: RoundedRectangle(cornerRadius: MMSpacing.cardCornerRadius))

            // New record
            if isNewRecord && showRecord {
                HStack(spacing: MMSpacing.sm) {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(MMColors.Semantic.streak)
                    Text("New Record!")
                        .font(MMFonts.title2)
                        .foregroundStyle(MMColors.Semantic.streak)
                }
                .transition(.scale.combined(with: .opacity))
            }

            // Action buttons
            VStack(spacing: MMSpacing.md) {
                Button(action: onTryAgain) {
                    Text("Try Again")
                        .font(MMFonts.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, MMSpacing.md)
                }
                .buttonStyle(.borderedProminent)

                Button(action: onHome) {
                    Text("Home")
                        .font(MMFonts.body)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, MMSpacing.md)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(MMSpacing.xl)
        .onAppear {
            if isNewRecord {
                withAnimation(MMAnimation.newRecord.delay(0.3)) {
                    showRecord = true
                }
            }
        }
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: MMSpacing.xs) {
            Text(value)
                .font(MMFonts.title1)
                .foregroundStyle(MMColors.Text.primary)
            Text(label)
                .font(MMFonts.caption)
                .foregroundStyle(MMColors.Text.secondary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)")
    }
}
