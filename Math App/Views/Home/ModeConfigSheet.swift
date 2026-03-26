import SwiftUI

struct ModeConfigSheet: View {
    let initialMode: TrainingMode
    let onStart: (TrainingMode) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var practiceCount: Double
    @State private var timeAttackSeconds: Double

    private var isPractice: Bool {
        if case .practice = initialMode { return true }
        return false
    }

    init(initialMode: TrainingMode, onStart: @escaping (TrainingMode) -> Void) {
        self.initialMode = initialMode
        self.onStart = onStart

        switch initialMode {
        case .practice(let count):
            _practiceCount = State(initialValue: Double(count))
            _timeAttackSeconds = State(initialValue: 60)
        case .timeAttack(let seconds):
            _practiceCount = State(initialValue: 10)
            _timeAttackSeconds = State(initialValue: Double(seconds))
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: MMSpacing.xxl) {
                if isPractice {
                    practiceConfig
                } else {
                    timeAttackConfig
                }

                Spacer()

                Button {
                    let mode: TrainingMode
                    if isPractice {
                        let count = Int(practiceCount)
                        AppSettings.shared.practiceCount = count
                        mode = .practice(count: count)
                    } else {
                        let seconds = Int(timeAttackSeconds)
                        AppSettings.shared.timeAttackSeconds = seconds
                        mode = .timeAttack(seconds: seconds)
                    }
                    onStart(mode)
                } label: {
                    Text("Start")
                        .font(MMFonts.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, MMSpacing.md)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(MMSpacing.xl)
            .navigationTitle(isPractice ? "Practice" : "Time Attack")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var practiceConfig: some View {
        VStack(spacing: MMSpacing.md) {
            Text("\(Int(practiceCount)) problems")
                .font(MMFonts.title1)
                .foregroundStyle(MMColors.Text.primary)

            Slider(value: $practiceCount, in: 5...50, step: 5) {
                Text("Problem count")
            }
            .tint(MMColors.Semantic.accent)
        }
    }

    private var timeAttackConfig: some View {
        VStack(spacing: MMSpacing.md) {
            Text(formatSeconds(Int(timeAttackSeconds)))
                .font(MMFonts.title1)
                .foregroundStyle(MMColors.Text.primary)

            Slider(value: $timeAttackSeconds, in: 10...300, step: 10) {
                Text("Duration")
            }
            .tint(MMColors.Semantic.accent)
        }
    }

    private func formatSeconds(_ seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds) seconds"
        }
        let min = seconds / 60
        let sec = seconds % 60
        if sec == 0 {
            return "\(min) min"
        }
        return "\(min)m \(sec)s"
    }
}
